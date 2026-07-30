<!-- AI GENERATED INFO SO I CAN LOOK UP STUFF -->

| Operation | 32-bit Float (`float`) | 64-bit Float (`double`) |
| :--- | :--- | :--- |
| **Move / Load / Store** | `movss` | `movsd` |
| **Add** | `addss` | `addsd` |
| **Subtract** | `subss` | `subsd` |
| **Multiply** | `mulss` | `mulsd` |
| **Divide** | `divss` | `divsd` |
| **Square Root** | `sqrtss` | `sqrtsd` |
| **Min Value** | `minss` | `minsd` |
| **Max Value** | `maxss` | `maxsd` |
| **Compare** | `comiss` / `ucomiss` | `comisd` / `ucomisd` |

### Conversion Instructions (Integer <-> Float)

| Conversion Direction | 32-bit Integer <-> Float | 64-bit Integer <-> Double |
| :--- | :--- | :--- |
| **Int to Float/Double** | `cvtsi2ss` | `cvtsi2sd` |
| **Float/Double to Int (Truncate)** | `cvttss2si` | `cvttsd2si` |
| **Float to Double** | `cvtss2sd` | — |
| **Double to Float** | — | `cvtsd2ss` |

### Registers

XMM0 - 7