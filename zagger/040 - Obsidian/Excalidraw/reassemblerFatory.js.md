---
mindmap-plugin: basic
created: 2023-11-03T22:29
updated: 2023-11-10T15:21
---

# wdi.ReassemblerFactory

## getPacketReassembler
- this.getSizeDefiner();
- this.getPacketController(sD, socketQ);
- return new wdi.PacketReassembler({packetController: pC});

## getSizeDefiner
- new wdi.SizeDefiner();

## getPacketController
- return new wdi.PacketController({socketQ: socketQ, sizeDefiner: sizeDefiner});