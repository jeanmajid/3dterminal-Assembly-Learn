<!-- AI GENERATED INFO SO I CAN LOOK UP STUFF -->

# x86-64 General Purpose Registers

| Register   | Size   | Purpose                   |
| ---------- | ------ | ------------------------- |
| `RAX`      | 64-bit | Accumulator, return value |
| `RBX`      | 64-bit | Base register             |
| `RCX`      | 64-bit | Counter, loop count       |
| `RDX`      | 64-bit | Data register             |
| `RSI`      | 64-bit | Source index              |
| `RDI`      | 64-bit | Destination index         |
| `RBP`      | 64-bit | Base/frame pointer        |
| `RSP`      | 64-bit | Stack pointer             |
| `R8`–`R15` | 64-bit | General purpose registers |

---

# Sub-registers

| 64-bit | 32-bit | 16-bit | 8-bit   |
| ------ | ------ | ------ | ------- |
| `RAX`  | `EAX`  | `AX`   | `AL/AH` |
| `RBX`  | `EBX`  | `BX`   | `BL/BH` |
| `RCX`  | `ECX`  | `CX`   | `CL/CH` |
| `RDX`  | `EDX`  | `DX`   | `DL/DH` |
| `RSI`  | `ESI`  | `SI`   | `SIL`   |
| `RDI`  | `EDI`  | `DI`   | `DIL`   |
| `RBP`  | `EBP`  | `BP`   | `BPL`   |
| `RSP`  | `ESP`  | `SP`   | `SPL`   |
| `R8`   | `R8D`  | `R8W`  | `R8B`   |

---

# Special Registers

| Register | Purpose                                           |
| -------- | ------------------------------------------------- |
| `RIP`    | Instruction pointer (address of next instruction) |
| `RFLAGS` | CPU flags register                                |
| `CS`     | Code segment                                      |
| `DS`     | Data segment                                      |
| `SS`     | Stack segment                                     |
| `ES`     | Extra segment                                     |
| `FS`     | Extra segment                                     |
| `GS`     | Extra segment                                     |

---

# RFLAGS Important Bits

| Flag | Name            | Meaning           |
| ---- | --------------- | ----------------- |
| `CF` | Carry Flag      | Unsigned overflow |
| `ZF` | Zero Flag       | Result was zero   |
| `SF` | Sign Flag       | Result negative   |
| `OF` | Overflow Flag   | Signed overflow   |
| `PF` | Parity Flag     | Even parity       |
| `AF` | Auxiliary Carry | BCD arithmetic    |
| `DF` | Direction Flag  | String direction  |

---

# Segment Registers (Legacy x86)

| Register | Function          |
| -------- | ----------------- |
| `CS`     | Code segment      |
| `DS`     | Data segment      |
| `SS`     | Stack segment     |
| `ES`     | Extra segment     |
| `FS`     | Thread/local data |
| `GS`     | Thread/local data |

---
