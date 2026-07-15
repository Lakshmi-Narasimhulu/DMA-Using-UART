# DMA Using UART

## Overview

This project implements a **Direct Memory Access (DMA) Controller** integrated with a **UART Transmitter** using **Verilog HDL**. The DMA controller transfers data directly from memory to the UART transmitter, reducing CPU intervention and improving data transfer efficiency. The design is developed and verified using **Xilinx Vivado**.

---

## Features

- UART Transmitter implemented in Verilog
- DMA Controller with internal memory
- Automatic multi-byte data transmission
- Busy-handshake synchronization
- Configurable baud rate
- CPU access monitoring
- Behavioral simulation and RTL verification

---

## Project Structure

```
DMA-Using-UART/
│
├── README.md
└── DMA Using UART/
    ├── Schematic.png
    ├── Waveform.png
    └── uart_dma.srcs/
        └── sources_1/
            └── new/
                └── uart_dma.v
```

---

## Tools Used

- Verilog HDL
- Xilinx Vivado
- Behavioral Simulation
- RTL Analysis

---

## Simulation Results

### RTL Schematic

![RTL Schematic](DMA%20Using%20UART/Schematic.png)

### Simulation Waveform

![Simulation Waveform](DMA%20Using%20UART/Waveform.png)

---

## Applications

- Embedded Systems
- FPGA-Based Communication
- UART Interfaces
- DMA-Based Data Transfer
- Serial Communication

---

## Future Improvements

- UART Receiver
- External Memory Interface
- FIFO Buffer
- AXI DMA Support
- Interrupt-Based DMA

---

## Author

**Pothula Lakshmi Narasimhulu**

Department of Electronics and Communication Engineering  
RGUKT RK Valley
