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
        print("Response:", ws.response)
        print("State:", ws.state)

        await asyncio.sleep(5)

        print("After 5 seconds:")
        print("State:", ws.state)
        print("Close code:", ws.close_code)
        print("Close reason:", ws.close_reason)

        await ws.close()

    except Exception as e:
        print("ERROR TYPE:", type(e).__name__)
        print("ERROR:", repr(e))

asyncio.run(main())