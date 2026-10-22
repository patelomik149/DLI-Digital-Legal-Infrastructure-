import asyncio
from pathlib import Path

from piwapp import Client, AuthenticationCreds


CREDS_FILE = Path("whatsapp_creds.json")
KEYS_FILE = Path("whatsapp_keys.json")
DB_FILE = Path("whatsapp.db")


def load_creds():
    if CREDS_FILE.exists():
        print("Loading existing WhatsApp credentials...")
        return AuthenticationCreds.from_json(
            CREDS_FILE.read_text(encoding="utf-8")
        )

    print("Creating new WhatsApp credentials...")
    creds = AuthenticationCreds.initial()
    CREDS_FILE.write_text(
        creds.to_json(),
        encoding="utf-8"
    )
    return creds


def save_creds(creds):
    CREDS_FILE.write_text(
        creds.to_json(),
        encoding="utf-8"
    )
    print("Credentials saved.")


async def main():

    creds = load_creds()

    client = Client(
        creds,
        keys_path=KEYS_FILE,
        db_path=DB_FILE,
        on_creds_update=save_creds,
    )

    async def connection_update(update):
        print("CONNECTION:", update)

        # QR code મળે ત્યારે PNG file બનાવો
        if "qr" in update:
            import qrcode

            qr_data = update["qr"]

            img = qrcode.make(qr_data)
            img.save("whatsapp_qr.png")

            print("QR code saved as: whatsapp_qr.png")

    async def pairing_success(data):
        print("PAIRING SUCCESS:", data)

    client.on("connection.update", connection_update)
    client.on("pairing.success", pairing_success)

    print("Starting WhatsApp connection...")

    try:
        await client.start()
    except KeyboardInterrupt:
        print("Stopping...")
        await client.stop()


if __name__ == "__main__":
    asyncio.run(main())

