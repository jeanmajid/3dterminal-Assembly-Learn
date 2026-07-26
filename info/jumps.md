<!-- AI GENERATED INFO SO I CAN LOOK UP STUFF -->

# x86/x86-64 Jump Instructions

## 1. Unconditional Jump

| Instruction | Meaning                          | Operation     |
| ----------- | -------------------------------- | ------------- |
| `JMP`       | Jump always                      | `IP ← target` |
| `JMP label` | Jump to label                    | Direct jump   |
| `JMP reg`   | Jump to address in register      | Indirect jump |
| `JMP [mem]` | Jump to address stored in memory | Memory jump   |

Example:

```asm
jmp loop_start
```

---

# 2. Conditional Jump Instructions

Conditional jumps depend on CPU flags in the **FLAGS/RFLAGS register**.

| Instruction           | Meaning              | Condition            | Flag Used |
| --------------------- | -------------------- | -------------------- | --------- |
| `JE` / `JZ`           | Jump if equal / zero | Result = 0           | ZF=1      |
| `JNE` / `JNZ`         | Jump if not equal    | Result ≠ 0           | ZF=0      |
| `JC` / `JB` / `JNAE`  | Jump if carry        | Unsigned below       | CF=1      |
| `JNC` / `JAE` / `JNB` | Jump if no carry     | Unsigned above/equal | CF=0      |
| `JO`                  | Jump overflow        | Overflow occurred    | OF=1      |
| `JNO`                 | Jump no overflow     | No overflow          | OF=0      |
| `JS`                  | Jump sign            | Negative result      | SF=1      |
| `JNS`                 | Jump no sign         | Positive result      | SF=0      |
| `JP` / `JPE`          | Jump parity          | Even parity          | PF=1      |
| `JNP` / `JPO`         | Jump no parity       | Odd parity           | PF=0      |

---

# 3. Unsigned Comparison Jumps

| Instruction   | Meaning        | Condition     |
| ------------- | -------------- | ------------- |
| `JA` / `JNBE` | Above          | CF=0 and ZF=0 |
| `JAE` / `JNB` | Above or equal | CF=0          |
| `JB` / `JNAE` | Below          | CF=1          |
| `JBE` / `JNA` | Below or equal | CF=1 or ZF=1  |

Example:

```asm
cmp eax, ebx
ja bigger
```

---

# 4. Signed Comparison Jumps

| Instruction   | Meaning       | Condition      |
| ------------- | ------------- | -------------- |
| `JG` / `JNLE` | Greater       | ZF=0 and SF=OF |
| `JGE` / `JNL` | Greater/equal | SF=OF          |
| `JL` / `JNGE` | Less          | SF≠OF          |
| `JLE` / `JNG` | Less/equal    | ZF=1 or SF≠OF  |

---

# 5. Loop and Counter Jumps

| Instruction         | Meaning            | Operation       |
| ------------------- | ------------------ | --------------- |
| `LOOP`              | Loop while RCX ≠ 0 | RCX-- then jump |
| `LOOPE` / `LOOPZ`   | Loop if equal      | RCX-- and ZF=1  |
| `LOOPNE` / `LOOPNZ` | Loop if not equal  | RCX-- and ZF=0  |
| `JCXZ`              | Jump if CX=0       | 16-bit          |
| `JECXZ`             | Jump if ECX=0      | 32-bit          |
| `JRCXZ`             | Jump if RCX=0      | 64-bit          |

---

# 6. Function / Procedure Jumps

| Instruction | Meaning               | Purpose                    |
| ----------- | --------------------- | -------------------------- |
| `CALL`      | Call procedure        | Push return address + jump |
| `RET`       | Return                | Pop return address         |
| `IRET`      | Return from interrupt | Restore CPU state          |

Example:

```asm
call print_message
...
ret
```

# Common Assembly Branch Pattern

```asm
cmp eax, ebx      ; compare values
je equal          ; jump if equal
jg greater        ; jump if greater
jl smaller        ; jump if less
jmp end           ; unconditional jump

equal:
    ; code

greater:
    ; code

smaller:
    ; code

end:
```
