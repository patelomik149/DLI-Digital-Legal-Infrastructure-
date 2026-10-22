import sqlite3
from datetime import datetime
import asyncio
import os
import random
import re
import threading
import time
import uuid
from email.message import EmailMessage
import smtplib

from dotenv import load_dotenv
from contextlib import asynccontextmanager
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

try:
    from piwapp import Client, ConnectionConfig, AuthenticationCreds
except ImportError:
    Client = None
    ConnectionConfig = None
    AuthenticationCreds = None


# ============================================================
# LOAD ENVIRONMENT
# ============================================================

load_dotenv()


# ============================================================
# FLASK APP
# ============================================================

@asynccontextmanager
async def lifespan(app: FastAPI):
    init_user_database()

    whatsapp_thread = threading.Thread(
        target=start_whatsapp,
        daemon=True,
    )
    whatsapp_thread.start()

    print()
    print("=" * 70)
    print("DLI FastAPI backend starting on http://127.0.0.1:5000")
    print("=" * 70)

    yield


app = FastAPI(
    title="DLI Backend API",
    version="1.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ============================================================
# OTP SETTINGS
# ============================================================

OTP_EXPIRY_SECONDS = 300
RESEND_COOLDOWN_SECONDS = 60


# ============================================================
# OTP STORAGE
# ============================================================

verification_store = {}
store_lock = threading.Lock()


# ============================================================
# WHATSAPP GLOBAL STATE
# ============================================================

whatsapp_client = None
whatsapp_loop = None

whatsapp_ready = threading.Event()


# ============================================================
# WHATSAPP SESSION FILES
# ============================================================

# IMPORTANT:
# These are the SAME files used by your working
# whatsapp_connect.py

BASE_DIR = os.path.dirname(
    os.path.abspath(__file__)
)

CREDS_FILE = os.path.join(
    BASE_DIR,
    "whatsapp_creds.json"
)

KEYS_FILE = os.path.join(
    BASE_DIR,
    "whatsapp_keys.json"
)

DB_FILE = os.path.join(
    BASE_DIR,
    "whatsapp.db"
)

# ============================================================
# USER DATABASE
# ============================================================

USERS_DB_FILE = os.path.join(
    BASE_DIR,
    "users.db"
)

# ============================================================
# INITIALIZE USER DATABASE
# ============================================================

def init_user_database():

    with sqlite3.connect(USERS_DB_FILE) as conn:

        # ----------------------------------------------------
        # USERS TABLE
        # ----------------------------------------------------

        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                email TEXT NOT NULL UNIQUE,
                phone TEXT NOT NULL UNIQUE,
                verified_at TEXT NOT NULL
            )
            """
        )

        # ----------------------------------------------------
        # LOGIN LOGS TABLE
        # ----------------------------------------------------

        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS login_logs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                identifier_type TEXT NOT NULL,
                email TEXT,
                phone TEXT,
                otp TEXT NOT NULL,
                requested_at TEXT NOT NULL,
                verified_at TEXT,
                status TEXT NOT NULL
            )
            """
        )

        conn.commit()

def save_verified_user(email: str, phone: str):
    verified_at = datetime.now().astimezone().isoformat(timespec="seconds")

    with sqlite3.connect(USERS_DB_FILE) as conn:
        conn.execute(
            """
            INSERT INTO users (email, phone, verified_at)
            VALUES (?, ?, ?)
            """,
            (email.lower(), phone, verified_at)
        )

        conn.commit()

def get_user_by_email(email: str):
    with sqlite3.connect(USERS_DB_FILE) as conn:
        conn.row_factory = sqlite3.Row

        return conn.execute(
            """
            SELECT *
            FROM users
            WHERE email = ?
            LIMIT 1
            """,
            (email.lower(),)
        ).fetchone()


def get_user_by_phone(phone: str):
    with sqlite3.connect(USERS_DB_FILE) as conn:
        conn.row_factory = sqlite3.Row

        return conn.execute(
            """
            SELECT *
            FROM users
            WHERE phone = ?
            LIMIT 1
            """,
            (phone,)
        ).fetchone()

def create_login_log(
    identifier_type: str,
    email: str,
    phone: str,
    otp: str,
):
    requested_at = datetime.now().astimezone().isoformat(timespec="seconds")

    with sqlite3.connect(USERS_DB_FILE) as conn:
        cursor = conn.execute(
            """
            INSERT INTO login_logs (
                identifier_type,
                email,
                phone,
                otp,
                requested_at,
                verified_at,
                status
            )
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """,
            (
                identifier_type,
                email,
                phone,
                otp,
                requested_at,
                None,
                "OTP_SENT",
            )
        )

        conn.commit()

        return cursor.lastrowid

def update_login_log_verified(log_id: int):
    verified_at = datetime.now().astimezone().isoformat(timespec="seconds")

    with sqlite3.connect(USERS_DB_FILE) as conn:
        conn.execute(
            """
            UPDATE login_logs
            SET verified_at = ?, status = ?
            WHERE id = ?
            """,
            (
                verified_at,
                "VERIFIED",
                log_id,
            )
        )

        conn.commit()

QR_FILE = os.path.join(
    BASE_DIR,
    "whatsapp_qr.png"
)


# ============================================================
# OTP GENERATOR
# ============================================================

def generate_otp() -> str:

    return f"{random.randint(0, 999999):06d}"


# ============================================================
# PHONE NUMBER NORMALIZATION
# ============================================================

def normalize_phone(value: str) -> str:

    digits = re.sub(
        r"\D",
        "",
        value or ""
    )

    if len(digits) == 10:
        return "91" + digits

    if len(digits) == 12 and digits.startswith("91"):
        return digits

    if len(digits) == 11 and digits.startswith("0"):
        return "91" + digits[1:]

    return ""


# ============================================================
# EMAIL VALIDATION
# ============================================================

def valid_email(value: str) -> bool:

    return bool(
        re.fullmatch(
            r"[^@\s]+@[^@\s]+\.[^@\s]+",
            value or ""
        )
    )


# ============================================================
# SEND EMAIL OTP
# ============================================================

def send_email_otp(
    receiver_email: str,
    otp: str
) -> None:

    sender_email = os.getenv(
        "EMAIL_ADDRESS"
    )

    sender_password = os.getenv(
        "EMAIL_PASSWORD"
    )

    if not sender_email or not sender_password:

        raise RuntimeError(
            "Email configuration is missing in backend/.env"
        )

    message = EmailMessage()

    message["Subject"] = (
        "Your DLI Email Verification OTP"
    )

    message["From"] = sender_email
    message["To"] = receiver_email

    message.set_content(
        "Hello,\n\n"
        f"Your DLI email verification OTP is: {otp}\n\n"
        "This OTP is valid for 5 minutes.\n\n"
        "If you did not request this OTP, you can ignore this email.\n\n"
        "Regards,\n"
        "DLI"
    )

    with smtplib.SMTP(
        "smtp.gmail.com",
        587,
        timeout=30
    ) as smtp:

        smtp.starttls()

        smtp.login(
            sender_email,
            sender_password
        )

        smtp.send_message(message)


# ============================================================
# SAVE WHATSAPP CREDENTIALS
# ============================================================

def save_whatsapp_creds(creds):

    with open(
        CREDS_FILE,
        "w",
        encoding="utf-8"
    ) as file:

        file.write(
            creds.to_json()
        )

    print(
        "WhatsApp credentials saved."
    )


# ============================================================
# WHATSAPP CONNECTION UPDATE
# ============================================================

async def on_connection(update: dict):

    connection = update.get(
        "connection"
    )

    print(
        "WhatsApp connection update:",
        connection or update
    )

    # --------------------------------------------------------
    # QR CODE
    # --------------------------------------------------------

    if update.get("qr"):

        qr_payload = update["qr"]

        print()
        print("=" * 70)
        print("WHATSAPP QR CODE READY")
        print(
            "Scan QR from WhatsApp -> Linked devices -> Link a device"
        )
        print(
            "QR image:",
            QR_FILE
        )
        print("=" * 70)

        try:

            import qrcode

            image = qrcode.make(
                qr_payload
            )

            image.save(
                QR_FILE
            )

            print(
                "QR code saved successfully."
            )

        except Exception as exc:

            print(
                "Could not save QR:",
                repr(exc)
            )

    # --------------------------------------------------------
    # CONNECTION OPEN
    # --------------------------------------------------------

    if connection == "open":

        print()
        print("=" * 70)

        print(
            "WhatsApp connected successfully."
        )

        print(
            "WhatsApp connected as:",
            (update.get("me") or {}).get("id")
        )

        print("=" * 70)

        whatsapp_ready.set()

    # --------------------------------------------------------
    # CONNECTION CLOSED
    # --------------------------------------------------------

    elif connection == "close":

        whatsapp_ready.clear()

        print(
            "WhatsApp connection closed."
        )

        if update.get("logged_out"):

            print(
                "WhatsApp session was logged out."
            )

        if update.get("reason") is not None:

            print(
                "WhatsApp close reason:",
                update.get("reason")
            )


# ============================================================
# WHATSAPP WORKER
# ============================================================

async def whatsapp_worker():

    global whatsapp_client
    global whatsapp_loop

    if Client is None:

        print(
            "ERROR: piwapp is not installed."
        )

        print(
            "Run: pip install piwapp"
        )

        return

    # --------------------------------------------------------
    # LOAD EXISTING SESSION
    # --------------------------------------------------------

    if os.path.exists(CREDS_FILE):

        try:

            print(
                "Loading existing WhatsApp credentials..."
            )

            with open(
                CREDS_FILE,
                "r",
                encoding="utf-8"
            ) as file:

                creds = AuthenticationCreds.from_json(
                    file.read()
                )

            print(
                "Loaded saved WhatsApp session."
            )

        except Exception as exc:

            print(
                "Saved WhatsApp session is invalid."
            )

            print(
                "Error:",
                repr(exc)
            )

            print(
                "Creating a new WhatsApp session..."
            )

            creds = AuthenticationCreds.initial()

    else:

        print(
            "No WhatsApp session found."
        )

        print(
            "Creating a new WhatsApp session..."
        )

        creds = AuthenticationCreds.initial()

    # --------------------------------------------------------
    # CREATE WHATSAPP CLIENT
    # --------------------------------------------------------

    try:

        whatsapp_loop = asyncio.get_running_loop()

        # IMPORTANT:
        # Same configuration as whatsapp_connect.py

        whatsapp_client = Client(
            creds,
            ConnectionConfig(),
            keys_path=KEYS_FILE,
            db_path=DB_FILE,
            on_creds_update=save_whatsapp_creds,
        )

        # ----------------------------------------------------
        # REGISTER CONNECTION EVENT
        # ----------------------------------------------------

        whatsapp_client.on(
            "connection.update",
            on_connection
        )

        print(
            "Starting WhatsApp client..."
        )

        await whatsapp_client.start()

        print(
            "WhatsApp client stopped."
        )

    except Exception as exc:

        whatsapp_ready.clear()

        print()
        print(
            "WhatsApp client error:"
        )

        print(
            repr(exc)
        )


# ============================================================
# START WHATSAPP THREAD
# ============================================================

def start_whatsapp():

    try:

        asyncio.run(
            whatsapp_worker()
        )

    except Exception as exc:

        print(
            "WhatsApp worker error:",
            repr(exc)
        )


# ============================================================
# SEND WHATSAPP MESSAGE
# ============================================================

def send_whatsapp_message(
    phone: str,
    message: str
) -> str:

    if not whatsapp_ready.is_set():

        raise RuntimeError(
            "WhatsApp is not connected. "
            "Please wait until the backend shows "
            "'WhatsApp connected successfully.'"
        )

    if whatsapp_client is None:

        raise RuntimeError(
            "WhatsApp client is not initialized."
        )

    if whatsapp_loop is None:

        raise RuntimeError(
            "WhatsApp event loop is not available."
        )

    # --------------------------------------------------------
    # CREATE JID
    # --------------------------------------------------------

    jid = f"{phone}@s.whatsapp.net"

    print()
    print(
        "Sending WhatsApp message..."
    )

    print(
        "To:",
        jid
    )

    # --------------------------------------------------------
    # SEND USING WHATSAPP EVENT LOOP
    # --------------------------------------------------------

    future = asyncio.run_coroutine_threadsafe(
        whatsapp_client.send_text(
            jid,
            message
        ),
        whatsapp_loop
    )

    try:

        message_id = future.result(
            timeout=30
        )

        print(
            "WhatsApp message sent."
        )

        print(
            "Message ID:",
            message_id
        )

        return message_id

    except Exception as exc:

        print(
            "WhatsApp message sending failed:"
        )

        print(
            repr(exc)
        )

        raise


# ============================================================
# SEND WHATSAPP OTP
# ============================================================

def send_whatsapp_otp(
    phone: str,
    otp: str
) -> None:

    message = (
        "Your DLI phone verification OTP is: "
        f"{otp}\n\n"
        "This OTP is valid for 5 minutes."
    )

    send_whatsapp_message(
        phone,
        message
    )


# ============================================================
# JSON ERROR
# ============================================================

def json_error(
    message: str,
    status=400,
):
    return JSONResponse(
        status_code=status,
        content={
            "success": False,
            "message": message,
        },
    )


# ============================================================
# HEALTH CHECK
# ============================================================

@app.get("/api/health")
async def health():

    return {

        "success": True,

        "email_configured": bool(
            os.getenv("EMAIL_ADDRESS")
            and
            os.getenv("EMAIL_PASSWORD")
        ),

        "whatsapp_connected":
            whatsapp_ready.is_set(),

    }


# ============================================================
# REGISTER START
# ============================================================

@app.post("/api/register/start")
async def register_start(request: Request):

    data = await request.json() if request else {}

    email = (
        data.get("email") or ""
    ).strip().lower()

    phone = normalize_phone(
        data.get("phone") or ""
    )

    terms = bool(
        data.get("termsAccepted")
    )

    # --------------------------------------------------------
    # VALIDATION
    # --------------------------------------------------------

    if not valid_email(email):

        return json_error(
            "Please enter a valid email address."
        )

    if not phone:

        return json_error(
            "Please enter a valid 10-digit mobile number."
        )

    if not terms:

        return json_error(
            "Please agree to the Terms & Conditions."
        )
    # --------------------------------------------------------
# CHECK EXISTING USER
# --------------------------------------------------------

    if get_user_by_email(email):

        return json_error(
            "This email is already registered.",
            409
        )

    if get_user_by_phone(phone):

        return json_error(
            "This mobile number is already registered.",
            409
        )
    # --------------------------------------------------------
    # CHECK WHATSAPP
    # --------------------------------------------------------

    if not whatsapp_ready.is_set():

        return json_error(
            "WhatsApp is not connected. "
            "Please wait until the backend shows "
            "'WhatsApp connected successfully.'",
            503
        )

    # --------------------------------------------------------
    # GENERATE OTP
    # --------------------------------------------------------

    now = time.time()

    verification_id = str(
        uuid.uuid4()
    )

    email_otp = generate_otp()
    phone_otp = generate_otp()

    # --------------------------------------------------------
    # STORE OTP
    # --------------------------------------------------------

    with store_lock:

        for record in verification_store.values():

            if (
                record["email"] == email
                and
                record["phone"] == phone
            ):

                if (
                    now - record["created_at"]
                    <
                    RESEND_COOLDOWN_SECONDS
                ):

                    remaining = int(
                        RESEND_COOLDOWN_SECONDS
                        -
                        (
                            now
                            -
                            record["created_at"]
                        )
                    )

                    return json_error(
                        f"Please wait {remaining} seconds "
                        "before requesting another OTP.",
                        429
                    )

        verification_store[
            verification_id
        ] = {

            "email": email,

            "phone": phone,

            "email_otp": email_otp,

            "phone_otp": phone_otp,

            "created_at": now,

            "expires_at":
                now + OTP_EXPIRY_SECONDS,

            "verified": False,
        }

    # --------------------------------------------------------
    # SEND OTP
    # --------------------------------------------------------

    try:

        print()
        print("=" * 70)

        print(
            "OTP REQUEST"
        )

        print(
            "Email:",
            email
        )

        print(
            "Phone:",
            phone
        )

        print(
            "Email OTP:",
            email_otp
        )

        print(
            "WhatsApp OTP:",
            phone_otp
        )

        print("=" * 70)

        # Email OTP

        send_email_otp(
            email,
            email_otp
        )

        print(
            "Email OTP sent successfully."
        )

        # WhatsApp OTP

        send_whatsapp_otp(
            phone,
            phone_otp
        )

        print(
            "WhatsApp OTP sent successfully."
        )

    except Exception as exc:

        with store_lock:

            verification_store.pop(
                verification_id,
                None
            )

        print(
            "OTP send error:",
            repr(exc)
        )

        return json_error(
            f"Could not send OTP. {exc}",
            502
        )

    # --------------------------------------------------------
    # RESPONSE
    # --------------------------------------------------------

    return {

        "success": True,

        "message":
            "OTP sent successfully to your "
            "email and WhatsApp number.",

        "verificationId":
            verification_id,

        "email":
            email,

        "phone":
            phone,

        "expiresIn":
            OTP_EXPIRY_SECONDS,

    }


# ============================================================
# VERIFY OTP
# ============================================================

@app.post("/api/register/verify")
async def register_verify(request: Request):

    data = await request.json() if request else {}

    verification_id = (
        data.get("verificationId") or ""
    ).strip()

    email_otp = (
        data.get("emailOtp") or ""
    ).strip()

    phone_otp = (
        data.get("phoneOtp") or ""
    ).strip()

    # --------------------------------------------------------
    # VALIDATION
    # --------------------------------------------------------

    if not verification_id:

        return json_error(
            "Verification session is missing. "
            "Please request OTP again."
        )

    if not re.fullmatch(
        r"\d{6}",
        email_otp
    ):

        return json_error(
            "Enter the 6-digit email OTP."
        )

    if not re.fullmatch(
        r"\d{6}",
        phone_otp
    ):

        return json_error(
            "Enter the 6-digit phone OTP."
        )

    # --------------------------------------------------------
    # VERIFY
    # --------------------------------------------------------

    with store_lock:

        record = verification_store.get(
            verification_id
        )

        if not record:

            return json_error(
                "OTP session not found. "
                "Please request OTP again."
            )

        if time.time() > record["expires_at"]:

            verification_store.pop(
                verification_id,
                None
            )

            return json_error(
                "OTP has expired. "
                "Please request a new OTP."
            )

        if email_otp != record["email_otp"]:

            return json_error(
                "Invalid email OTP."
            )

        if phone_otp != record["phone_otp"]:

            return json_error(
                "Invalid phone OTP."
            )

        record["verified"] = True

        # Save verified user into database
        try:
            save_verified_user(
                record["email"],
                record["phone"]
            )
        except sqlite3.IntegrityError:
            verification_store.pop(
                verification_id,
                None
            )

            return json_error(
                "This email or mobile number is already registered.",
                409
            )

        verification_store.pop(
            verification_id,
            None
        )

    # --------------------------------------------------------
    # SUCCESS
    # --------------------------------------------------------

    return {

        "success": True,

        "message":
            "Email and phone number verified successfully!"

    }


# ============================================================
# RESEND OTP
# ============================================================

@app.post("/api/register/resend")
async def register_resend(request: Request):

    data = await request.json() if request else {}

    verification_id = (
        data.get("verificationId") or ""
    ).strip()

    # --------------------------------------------------------
    # GET RECORD
    # --------------------------------------------------------

    with store_lock:

        record = verification_store.get(
            verification_id
        )

        if not record:

            return json_error(
                "OTP session not found. "
                "Please start registration again."
            )

        now = time.time()

        if (
            now - record["created_at"]
            <
            RESEND_COOLDOWN_SECONDS
        ):

            remaining = int(
                RESEND_COOLDOWN_SECONDS
                -
                (
                    now
                    -
                    record["created_at"]
                )
            )

            return json_error(
                f"Please wait {remaining} seconds "
                "before requesting another OTP.",
                429
            )

        # Generate new OTPs

        record["email_otp"] = generate_otp()

        record["phone_otp"] = generate_otp()

        record["created_at"] = now

        record["expires_at"] = (
            now + OTP_EXPIRY_SECONDS
        )

        email = record["email"]

        phone = record["phone"]

        email_otp = record["email_otp"]

        phone_otp = record["phone_otp"]

    # --------------------------------------------------------
    # SEND NEW OTP
    # --------------------------------------------------------

    try:

        send_email_otp(
            email,
            email_otp
        )

        send_whatsapp_otp(
            phone,
            phone_otp
        )

    except Exception as exc:

        print(
            "Resend error:",
            repr(exc)
        )

        return json_error(
            f"Could not resend OTP. {exc}",
            502
        )

    return {

        "success": True,

        "message":
            "A new OTP was sent to your "
            "email and WhatsApp number."

    }


# ============================================================
# LOGIN OTP
# ============================================================

@app.post("/api/login/start")
async def login_start(request: Request):
    data = await request.json() if request else {}

    identifier = (data.get("identifier") or "").strip()

    if not identifier:
        return json_error("Please enter your email address or mobile number.")

    # Email or Mobile detect
    if "@" in identifier:
        email = identifier.lower()

        if not valid_email(email):
            return json_error("Please enter a valid email address.")

        # Check whether email is registered
        user = get_user_by_email(email)

        if not user:
            return json_error(
                "This email is not registered.",
                404
            )

        login_type = "email"
        phone = ""
        email_otp = generate_otp()
        phone_otp = ""

    else:
        phone = normalize_phone(identifier)

        if not phone:
            return json_error("Please enter a valid 10-digit mobile number.")

        # Check whether mobile is registered
        user = get_user_by_phone(phone)

        if not user:
            return json_error(
                "This mobile number is not registered.",
                404
            )

        login_type = "mobile"
        email = ""
        email_otp = ""
        phone_otp = generate_otp()

    # -------------------------------------------------
    # COMMON LOGIN OTP PROCESS
    # This must be OUTSIDE the email/mobile if-else
    # -------------------------------------------------

    now = time.time()
    verification_id = str(uuid.uuid4())

    try:
        if login_type == "email":
            send_email_otp(email, email_otp)
            message = "OTP sent successfully to your email."

        else:
            send_whatsapp_otp(phone, phone_otp)
            message = "OTP sent successfully to your WhatsApp number."

        # Create login log after OTP is sent successfully
        log_id = create_login_log(
            login_type,
            email,
            phone,
            email_otp if login_type == "email" else phone_otp
        )

    except Exception as exc:
        print("Login OTP send error:", exc)

        return json_error(
            f"Could not send OTP. {exc}",
            502
        )

    # Store verification data after log is created
    with store_lock:
        verification_store[verification_id] = {
            "type": login_type,
            "email": email,
            "phone": phone,
            "email_otp": email_otp,
            "phone_otp": phone_otp,
            "created_at": now,
            "expires_at": now + OTP_EXPIRY_SECONDS,
            "verified": False,
            "log_id": log_id,
        }

    return {
        "success": True,
        "message": message,
        "verificationId": verification_id,
        "logId": log_id,
        "type": login_type,
        "email": email,
        "phone": phone,
        "expiresIn": OTP_EXPIRY_SECONDS,
    }

@app.post("/api/login/verify")
async def login_verify(request: Request):
    data = await request.json() if request else {}

    verification_id = (data.get("verificationId") or "").strip()
    otp = (data.get("otp") or "").strip()

    if not verification_id:
        return json_error("Verification ID is required.")

    if not re.fullmatch(r"\d{6}", otp):
        return json_error("Enter the 6-digit OTP.")

    with store_lock:
        record = verification_store.get(verification_id)

        if not record:
            return json_error(
                "Verification session not found. Please request a new OTP."
            )

        if time.time() > record["expires_at"]:
            verification_store.pop(verification_id, None)
            return json_error(
                "OTP has expired. Please request a new OTP."
            )

        if record["type"] == "email":
            if otp != record["email_otp"]:
                return json_error("Invalid email OTP.")
        else:
            if otp != record["phone_otp"]:
                return json_error("Invalid WhatsApp OTP.")

        record["verified"] = True

        # Update login log after successful OTP verification
        try:
            update_login_log_verified(
                record["log_id"]
            )
        except Exception as exc:
            print(
                "Login log update error:",
                repr(exc)
            )

        verification_store.pop(
            verification_id,
            None
        )

    return {
        "success": True,
        "message": "Login verification successful!",
        "type": record["type"],
    }


@app.post("/api/login/resend")
async def login_resend(request: Request):
    data = await request.json() if request else {}

    verification_id = (data.get("verificationId") or "").strip()

    if not verification_id:
        return json_error("Verification ID is required.")

    now = time.time()

    with store_lock:
        record = verification_store.get(verification_id)

        if not record:
            return json_error(
                "Verification session not found. Please request a new OTP."
            )

        login_type = record["type"]
        email = record["email"]
        phone = record["phone"]

        new_otp = generate_otp()

        if login_type == "email":
            record["email_otp"] = new_otp
        else:
            record["phone_otp"] = new_otp

        record["created_at"] = now
        record["expires_at"] = now + OTP_EXPIRY_SECONDS

    try:
        if login_type == "email":
            send_email_otp(email, new_otp)
            message = "OTP resent successfully to your email."
        else:
            send_whatsapp_otp(phone, new_otp)
            message = "OTP resent successfully to your WhatsApp number."

    except Exception as exc:
        print("Login OTP resend error:", exc)
        return json_error(f"Could not resend OTP. {exc}", 502)

    return {
        "success": True,
        "message": message,
        "verificationId": verification_id,
        "type": login_type,
        "expiresIn": OTP_EXPIRY_SECONDS,
    }


# ============================================================
# START APPLICATION
# ============================================================

if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        app,
        host="127.0.0.1",
        port=5000,
        log_level="info",
    )
