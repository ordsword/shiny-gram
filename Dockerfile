FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir telethon aiohttp cryptg

COPY server.py .

EXPOSE 443

CMD ["python", "server.py"]

