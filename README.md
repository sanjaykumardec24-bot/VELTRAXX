
# VELTRAXX'26 – PS 01

# Low-Power Clock Gating Controller for Mobile SoC

## 1. Project Overview

This project focuses on the design of a low-power clock gating controller for a mobile System-on-Chip (SoC) using SystemVerilog RTL.

In a typical SoC, different functional blocks do not need to operate continuously. If the clock is supplied to an inactive block, unnecessary switching activity can occur, which increases dynamic power consumption.

The proposed design controls the clock supplied to individual functional blocks and disables the clock when the block is not required.

The design supports clock gating for:

- CPU
- SRAM
- GPIO
- Timer
- UART

The controller also includes asynchronous wake-up synchronization and test/scan enable support.

**Domain:** RTL-to-GDSII (ASIC Flow)

---

## 2. Problem Statement

The objective of PS 01 is to design a low-power clock gating controller that can safely control clocks for different functional blocks in a mobile SoC.

The design focuses on:

- Individual clock gating
- Asynchronous wake-up handling
- Glitch-free clock gating
- Runt-pulse prevention
- Test/scan operation
- Low gating and ungating latency
- RTL simulation and verification
- ASIC synthesis and timing analysis

---

## 3. Why Clock Gating?

Clock signals are continuously switching in digital circuits. When a functional block is inactive, allowing its clock to continue switching can result in unnecessary dynamic power consumption.

Clock gating reduces this activity by stopping the clock when the corresponding block is not required.

```text
Inactive Block
      |
      v
Clock Disabled
      |
      v
Less Switching Activity
      |
      v
Reduced Dynamic Power
````

Clock gating is used in this project as the main low-power technique for controlling unnecessary clock activity at the RTL level.

---

## 4. Design Architecture

The controller receives a global clock and individual enable signals for each SoC block.

The asynchronous wake-up signal is first passed through a synchronizer. The synchronized wake-up signal, functional enable and test enable are then used to generate the final gate enable.

```text
                         +----------------+
                         |   Global Clock |
                         |      clk       |
                         +-------+--------+
                                 |
              +------------------+------------------+
              |                  |                  |
              v                  v                  v
       +-------------+    +-------------+    +-------------+
       | Wake-Up     |    | Functional  |    | Test/Scan   |
       | Synchronizer|    | Enables     |    | Enable      |
       +------+------+    +------+------+    +------+------+
              |                  |                  |
              +------------------+------------------+
                                 |
                                 v
                    +-------------------------+
                    | Gate Enable Generation  |
                    +-----------+-------------+
                                |
              +-----------------+-----------------+
              |        |        |        |        |
              v        v        v        v        v
             CPU      SRAM     GPIO     Timer     UART
              |        |        |        |        |
              v        v        v        v        v
           CPU_CLK  SRAM_CLK GPIO_CLK TIMER_CLK UART_CLK
```

---

## 5. Functional Blocks

| Functional Block | Enable Signal  | Gated Clock |
| ---------------- | -------------- | ----------- |
| CPU              | `cpu_enable`   | `cpu_clk`   |
| SRAM             | `sram_enable`  | `sram_clk`  |
| GPIO             | `gpio_enable`  | `gpio_clk`  |
| Timer            | `timer_enable` | `timer_clk` |
| UART             | `uart_enable`  | `uart_clk`  |

Additional control signals:

| Signal         | Description                  |
| -------------- | ---------------------------- |
| `clk`          | Main system clock            |
| `rst_n`        | Active-low reset             |
| `async_wakeup` | Asynchronous wake-up request |
| `test_enable`  | Test/scan enable             |
| `wake_sync`    | Synchronized wake-up signal  |

---

## 6. Wake-Up Synchronization

The `async_wakeup` signal can change independently of the main system clock. Therefore, a configurable synchronizer is used before the signal is applied to the clock gating logic.

The number of synchronizer stages is controlled using:

```systemverilog
parameter int SYNC_STAGES = 2
```

Basic operation:

```text
async_wakeup
     |
     v
+-----------+
| Wake FF 1 |
+-----+-----+
      |
      v
+-----------+
| Wake FF 2 |
+-----+-----+
      |
      v
  wake_sync
```

The synchronized wake-up signal is then used by the clock gate enable logic.

---

## 7. Clock Gate Enable Generation

For each functional block, the final gate enable is generated using the functional enable, synchronized wake-up signal and test enable.

```text
Gate Enable = Functional Enable
              OR Wake-Up
              OR Test Enable
```

For example, for the CPU:

```systemverilog
assign cpu_gate_en =
        cpu_enable |
        wake_sync  |
        test_enable;
```

The same control structure is used for SRAM, GPIO, Timer and UART.

---

## 8. Clock Gating Method

The gate enable is latched on the negative edge of the main clock.

Example:

```systemverilog
always_ff @(negedge clk or negedge rst_n) begin
    if (!rst_n)
        cpu_en_latched <= 1'b0;
    else
        cpu_en_latched <= cpu_gate_en;
end
```

The gated clock is then generated using the latched enable:

```systemverilog
assign cpu_clk = clk & cpu_en_latched;
```

The same method is applied to the other functional blocks.

Using the latched enable keeps the gating control stable during the active clock phase and helps to avoid unwanted clock transitions.

---

## 9. Activity Monitoring

The RTL includes activity counters for the global clock and individual functional blocks.

The counters are used during simulation to observe clock activity.

For example:

```systemverilog
if (cpu_clk)
    cpu_activity <= cpu_activity + 8'h01;
```

When the CPU clock is active, the activity counter increases. When the CPU clock is gated, the counter does not increase.

Activity counters are included for:

* Global clock
* CPU
* SRAM
* GPIO
* Timer
* UART

---

## 10. Verification

The design is verified using SystemVerilog testbench files.

The verification covers the main operating conditions of the clock gating controller.

### Main Test Cases

1. Reset operation
2. CPU clock enable and disable
3. SRAM clock enable and disable
4. GPIO clock enable and disable
5. Timer clock enable and disable
6. UART clock enable and disable
7. Multiple blocks enabled at the same time
8. Asynchronous wake-up
9. Test/scan enable
10. Gated clock behaviour
11. Clock transition checking
12. Activity counter checking

Simulation logs and waveform results are maintained in the project folders.

---

## 11. ASIC Synthesis Flow

After RTL verification, the design is prepared for ASIC synthesis.

The synthesis flow includes:

```text
SystemVerilog RTL
        |
        v
     Read RTL
        |
        v
    Elaboration
        |
        v
   Apply SDC
 Constraints
        |
        v
    DFT / Scan
   Configuration
        |
        v
 Generic Synthesis
        |
        v
 Technology Mapping
        |
        v
    Optimization
        |
        v
 Area / Power / Timing Reports
```

Cadence Genus is used for the synthesis stage.

---

## 12. Timing Constraints

The design uses an SDC file for timing analysis.

The constraint file includes:

* Clock definition
* Clock transition
* Clock gating check
* Input delays
* Output delays
* Clock uncertainty

Current constraint file:

```text
constraints/constraints_soccon.sdc
```

---

## 13. Synthesis Reports

The synthesis flow generates reports related to:

* Area
* Power
* Timing
* Gate count
* Scan chains
* Timing summary
* Synthesized netlist

The synthesis script is available under:

```text
scripts/simulation/synthesis/
```

The synthesis documentation is maintained under:

```text
docs/synthesis_reports/
```

Generated outputs are maintained under the `outputs` directory.

---

## 14. Repository Structure

```text
VELTRAXX/
│
├── README.md
│
├── src/
│   ├── clock_gating_controller.sv
│   └── design.sv
│
├── tb/
│   ├── interface.sv
│   ├── pkg.sv
│   ├── tb.sv
│   └── tb_clock_gating_controller.sv
│
├── constraints/
│   └── constraints_soccon.sdc
│
├── scripts/
│   └── simulation/
│       └── synthesis/
│           └── synthesis.tcl
│
├── logs/
│   └── simulation.log
│
├── outputs/
│   ├── waveforms/
│   ├── netlist/
│   └── timing_reports/
│
├── docs/
│   └── synthesis_reports/
│       └── synthesis_results.docx
│
└── presentation/
```

---

## 15. Tools Used

| Tool            | Purpose            |
| --------------- | ------------------ |
| SystemVerilog   | RTL Design         |
| Cadence Xcelium | RTL Simulation     |
| Cadence Genus   | Logic Synthesis    |
| GTKWave         | Waveform Viewing   |
| SDC             | Timing Constraints |
| Git             | Version Control    |
| GitHub          | Project Repository |

---

## 16. Research Background

The project was developed after studying research related to low-power SoC design and clock gating.

The literature study covered:

* Clock gating
* Glitch-free clock control
* Low-power design techniques
* Clock gating for SoC applications
* Automated clock-gating architectures
* Power management in SoCs

The research study helped us understand different low-power techniques and select clock gating for the proposed design.

---

## 17. Project Information

**Event:** VELTRAXX'26

**Problem Statement:** PS 01

**Project:** Low-Power Clock Gating Controller for Mobile SoC

**Domain:** RTL-to-GDSII (ASIC Flow)

---
