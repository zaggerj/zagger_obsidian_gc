---
mindmap-plugin: basic
created: 2023-11-03T22:29
updated: 2023-11-10T15:21
---

# wdi.PacketReassembler

## init
- setListeners
    - this.packetController.addListener('chunkComplete'
        - 'spicePacket'
            - this.fire('packetComplete', rawMessage);
    - this.packetController.addListener('error',
        - this.fire('error', e);
- this.statusToString
- this.packetController