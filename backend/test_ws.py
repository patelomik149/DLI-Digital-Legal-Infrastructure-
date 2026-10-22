import asyncio
import websockets

async def main():
    url = "wss://web.whatsapp.com/ws/chat"

    try:
        print("Connecting...")

        ws = await websockets.connect(
            url,
            additional_headers={
                "Origin": "https://web.whatsapp.com"
            },
            open_timeout=20,
            ping_interval=None,
            max_size=2**24,
        )

        print("CONNECTED")
        await ws.close()

    except Exception as e:
        print("ERROR TYPE:", type(e).__name__)
        print("ERROR:", repr(e))


asyncio.run(main())