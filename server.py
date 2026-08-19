import asyncio
import logging

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(message)s")

async def handle_client(reader, writer):
    addr = writer.get_extra_info('peername')
    logging.info(f"Connected client: {addr}")
    try:
        while True:
            data = await reader.read(4096)
            if not data:
                break
            # Echo MTProto handshake ACK
            writer.write(data)
            await writer.drain()
    except Exception as e:
        logging.error(f"Connection error: {e}")
    finally:
        writer.close()
        await writer.wait_closed()
        logging.info(f"Disconnected client: {addr}")

async def main():
    server = await asyncio.start_server(handle_client, '0.0.0.0', 443)
    logging.info("Telegram Mock Server listening on port 443")
    async with server:
        await server.serve_forever()

if __name__ == "__main__":
    asyncio.run(main())
  
