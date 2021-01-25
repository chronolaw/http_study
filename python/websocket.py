#!/usr/bin/python

# Copyright (C) 2021 by chrono

import asyncio
import websockets

async def hello(uri) :

    async with websockets.connect(uri) as ws :
        name = 'monado'

        await ws.send(name)
        print(f'> {name}')

        greeting = await ws.recv()
        print(f'< {greeting}')

def main() :

    uri = "ws://127.0.0.1/38-0"

    asyncio.run(hello(uri))

if __name__ == '__main__':
    main()
