import asyncio
from pathlib import Path

from piwapp import Client, AuthenticationCreds


CREDS_FILE = Path("whatsapp_creds.json")
KEYS_FILE = Path("whatsapp_keys.json")
DB_FILE = Path("whatsapp.db")


async def main():

    creds = AuthenticationCreds.from_json(
        CREDS_FILE.read_text(encoding="utf-8")
    )

    client = Client(
        creds,
        keys_path=KEYS_FILE,
        db_path=DB_FILE,
    )

    connected = asyncio.Event()

    async def connection_update(update):
        print("CONNECTION:", update)

        if update.get("connection") == "open":
            connected.set()

    client.on("connection.update", connection_update)

    print("Connecting to WhatsApp...")

    # WhatsApp connection start કરો
    start_task = asyncio.create_task(client.start())

    # Connection open થાય ત્યાં સુધી રાહ જુઓ
    await connected.wait()

    print("WhatsApp connected!")

    # ------------------------------------------------
    # અહીં message મોકલવો
    # ------------------------------------------------

    to_jid = "919727914221@s.whatsapp.net"
    message = "Hello! This message was sent from Python."

    print("Sending message...")

    try:
        message_id = await client.send_text(
            to_jid,
            message
        )

        print("Message sent successfully!")
        print("Message ID:", message_id)

    except Exception as e:
        print("Message sending failed!")
        print("Error:", repr(e))

    # Connection થોડા સમય ચાલુ રાખો
    await asyncio.sleep(3)

    await client.stop()

    # Background task cleanly stop કરો
    if not start_task.done():
        start_task.cancel()

        try:
            await start_task
        except asyncio.CancelledError:
            pass


if __name__ == "__main__":
    asyncio.run(main())
