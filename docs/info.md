<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The design is an 8-bit SIMD (Single Instruction Multiple Data) ALU.

The 8-bit input (ui_in) is internally split into four 2-bit lanes. A 3-bit opcode is formed using bits ui[7], ui[6], and ui[0]. Based on this opcode, each lane performs the same operation (ADD, SUB, XOR, AND, OR, SHIFT, etc.) in parallel.

To increase hardware utilization and demonstrate complex datapath behavior, the input is transformed into multiple variants (bitwise XOR, inversion, rotation, and bit rearrangement). Each variant is processed by identical SIMD blocks.

The outputs of all SIMD blocks are then combined using XOR and addition (reduction tree), producing a mixed result. This result passes through multiple pipeline stages (registers), introducing clock-cycle delay and increasing hardware complexity.

Finally, a small FSM modifies the output differently in each clock cycle, producing dynamic output behavior.

Overall flow:
Input → Transform → Parallel SIMD processing → Mixing → Pipeline → FSM → Output

## How to test

Provide an 8-bit input on ui_in.

- Bits ui[7], ui[6], and ui[0] select the operation (opcode).
- Remaining bits act as data.

Apply different input values and observe the output on uo_out.

Since the design contains pipeline stages, the output will appear after a few clock cycles (latency). The FSM causes the output to change every cycle even if the input remains constant.

To verify functionality:
1. Apply a known input (e.g., 0x24).
2. Wait for a few clock cycles.
3. Observe changing outputs due to FSM states.

## External hardware

No external hardware is required.

The design can be tested using:
- FPGA board
- Tiny Tapeout test board
- Microcontroller (e.g., ESP32) to drive inputs and read outputs
