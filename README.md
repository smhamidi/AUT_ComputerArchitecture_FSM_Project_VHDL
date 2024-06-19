# Computer Architecture Project
### 1401.2 Semester AUT

**Author:** Seyyed Mohammad Hamidi  
**Date:** June 1, 2023

---

## Abstract

In this project, we present a Finite State Machine (FSM) designed as a sequential circuit to control operations in digital systems. Our FSM operates in four states: Fetch, Decode, Read Signal, and Execute.

The code defines states and initializes control signals like PC (Program Counter), opcode, and various clock signals (ALU, RAM, ROM). The FSM orchestrates the interaction between ALU, RAM, and ROM modules through port mappings and state transitions based on clock and reset signals.

---

## Overview

The provided VHDL module, `FSM`, simulates a basic computer's instruction cycle. It incorporates components like `ALU`, `RAM`, and `ROM` and cycles through four states: Fetch, Decode, Read, and Execute. The FSM is sensitive to clock (`clk`) and reset signals.

### FSM Architecture

#### Signals

- **State Signal**
- **Accumulator (AC)**
- **Data Register (DR)**
- **Instruction Register (IR)**
- **Carry Flag (E)**
- **Program Counter (PC)**
- **Opcode**
- **Address**
- **Clock Signals:** ALU_clk, RAM_clk, ROM_clk
- **Control Signals:** init_start, FSM_done, done signals for each component

#### Components

- **ALU**: Arithmetic Logic Unit
- **RAM**: Random Access Memory
- **ROM**: Read-Only Memory

#### Port Maps

Port maps define the connections between components and signals, establishing the FSM's interface.

---

## Main Process and State Transitions

### Fetch State

- Increment PC
- Fetch instruction from ROM
- Transition to Decode state

### Decode State

- Extract opcode and address
- Transition to Read state

### Read State

- Fetch operand from RAM if needed
- Transition to Execute state

### Execute State

- Perform ALU operations
- Transition back to Fetch state

---

## Code Explanation

The FSM models a simple computer's operation using VHDL, incorporating ALU for arithmetic operations, RAM for memory operations, and ROM for program storage. It follows a synchronous sequential circuit design, controlled by clock and reset signals.

---

## ALU Module

### Functions Package

Defines functions like `multiply` and `SQR`:

- **Multiply**: Multiplies two 16-bit numbers.
- **SQR**: Calculates the square root of a number.

### ALU Entity

- **Inputs**: Two 16-bit data inputs (AC, DR), 6-bit opcode, ALU_clk
- **Outputs**: 16-bit result (ALU_out), carry-out flag (E_out), PC increment signal (inc_PC), operation complete signal (done)

### ALU Behavioral Architecture

The ALU operates based on the opcode, performing various arithmetic and logic operations.

---

## RAM Module

### Overview

The RAM module supports data reading and writing operations synchronized with a system clock.

### Code Description

- **Libraries**: Uses IEEE libraries for logic and numeric operations.
- **Entity**: Defines ports for address, data input/output, control signals, and clock.
- **Architecture**: Implements a memory array and processes data read/write operations based on control signals.

---

## ROM Module

### Overview

The ROM module is a read-only memory with 1024 16-bit instructions, synchronized with a system clock.

### Ports Description

- **ROM_clk**: Clock signal
- **Address**: 10-bit address line
- **inst_out**: 16-bit instruction output
- **ROM_needed**: Control signal for reading
- **done**: Indicates read operation completion

### Internal Architecture

Defines a memory array and processes read operations based on the clock and control signals.

---

## Conclusion

This project effectively demonstrates the design and operation of an FSM controlling a simple computer system. The VHDL modules for ALU, RAM, and ROM are well-structured, showcasing basic digital design principles and synchronous operations.
