# VELTRAXX'26 – PS 01

## Low-Power Clock Gating Controller for Mobile SoC

### 📌 Project Overview

This project implements a **Low-Power Clock Gating Controller for a Mobile SoC** using synthesizable SystemVerilog RTL.

The design selectively enables or disables the clock supplied to different functional blocks based on their enable requests. It also supports **asynchronous wake-up handling**, **test/scan enable**, and **glitch-free clock gating**.

**Focused Domain:** RTL-to-GDSII (ASIC Flow)

---

## 🎯 Objectives

* Reduce dynamic power by disabling clocks to inactive functional blocks.
* Implement safe and synthesizable clock-gating logic.
* Support multiple SoC functional blocks.
* Handle asynchronous wake-up requests through synchronization.
* Prevent clock glitches and runt pulses during gating and ungating.
* Provide test/scan enable functionality.
* Verify clock-gating behavior through simulation.
* Evaluate the design for ASIC synthesis and timing closure.

---

## 🏗️ Functional Blocks

The current RTL design supports clock gating for five functional blocks:

| Functional Block | Enable Input   | Gated Clock |
| ---------------- | -------------- | ----------- |
| CPU              | `cpu_enable`   | `cpu_clk`   |
| SRAM             | `sram_enable`  | `sram_clk`  |
| GPIO             | `gpio_enable`  | `gpio_clk`  |
| Timer            | `timer_enable` | `timer_clk` |
| UART             | `uart_enable`  | `uart_clk`  |

Additional control signals:

* `async_wakeup` – asynchronous peripheral wake-up request
* `test_enable` – test/scan clock enable
* `rst_n` – active-low reset
* `clk` – global clock

---

## 🔧 Design Architecture

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
                    | Clock Gate Enable      |
                    | Generation             |
                    +-----------+-------------+
                                |
                    +-----------+-----------+
                    |           |           |
                    v           v           v
                CPU Gate    SRAM Gate    GPIO Gate
                    |           |           |
                    v           v           v
                 CPU CLK     SRAM CLK    GPIO CLK

                    +-----------+-----------+
                                |
                         Timer / UART Gates
                                |
                         Timer CLK / UART CLK
```

---

## ⚙️ Working Principle

### 1. Functional Enable Control

Each SoC block has an individual enable signal:

```text
cpu_enable
sram_enable
gpio_enable
timer_enable
uart_enable
```

The corresponding clock is enabled when the functional block requires operation.

---

### 2. Asynchronous Wake-Up Synchronization

The `async_wakeup` signal is asynchronous to the main clock.

A configurable multi-stage synchronizer is used:

```text
async_wakeup
     |
     v
+----------+
| Wake FF  |
| Stage 1  |
+----+-----+
     |
     v
+----------+
| Wake FF  |
| Stage 2  |
+----+-----+
     |
     v
 wake_sync
```

The number of synchronization stages is controlled by:

```systemverilog
parameter int SYNC_STAGES = 2
```

The synchronized wake-up signal is then used to enable the clocks safely.

---

## 🔐 Clock Gate Enable Logic

For each functional block, the final gate enable is generated using:

```text
Gate Enable = Functional Enable OR Wake-Up OR Test Enable
```

For example:

```systemverilog
assign cpu_gate_en =
        cpu_enable |
        wake_sync  |
        test_enable;
```

The same control scheme is applied to SRAM, GPIO, Timer, and UART.

---

## 🕒 Glitch-Free Clock Gating

The clock enable is captured on the **negative edge** of the main clock.

Example:

```systemverilog
always_ff @(negedge clk or negedge rst_n) begin
    if (!rst_n)
        cpu_en_latched <= 1'b0;
    else
        cpu_en_latched <= cpu_gate_en;
end
```

The gated clock is then generated as:

```systemverilog
assign cpu_clk = clk & cpu_en_latched;
```

Capturing the enable on the falling edge prevents the enable signal from changing during the active high phase of the clock.

This architecture is intended to provide safe clock gating without glitches or runt pulses.

---

## 📊 Activity Monitoring

The RTL also contains activity counters for:

* Global clock
* CPU
* SRAM
* GPIO
* Timer
* UART

These counters can be used during simulation to observe whether a functional block is receiving clock activity.

For example:

```systemverilog
if (cpu_clk)
    cpu_activity <= cpu_activity + 8'h01;
```

When the CPU clock is gated, CPU clock activity stops increasing.

---

## ⚡ Power-Saving Concept

```text
Functional Block Active
        |
        v
   Clock Enabled
        |
        v
   Normal Operation


Functional Block Inactive
        |
        v
    Clock Gated
        |
        v
 Reduced Clock Switching
        |
        v
   Dynamic Power Saving
```

The main objective is to reduce unnecessary **dynamic power caused by clock switching** in inactive SoC blocks.

---

## 🧪 Verification Plan

The design should be verified using a self-checking testbench.

### Test Cases

1. Reset operation
2. CPU clock enable
3. CPU clock disable
4. SRAM clock enable/disable
5. GPIO clock enable/disable
6. Timer clock enable/disable
7. UART clock enable/disable
8. Multiple functional blocks enabled simultaneously
9. Asynchronous wake-up event
10. Test/scan enable
11. Clock gating during enable transitions
12. Glitch-free clock verification
13. Runt-pulse verification
14. Activity-counter verification
15. Boundary and corner-case testing

---

## 📈 PS01 Design Requirements

The implementation is targeted to satisfy the official PS01 constraints:

| Requirement             |      Target |
| ----------------------- | ----------: |
| Asynchronous Wake-Up    |   Supported |
| Glitch-Free Operation   |    Required |
| Runt Pulses             | Not allowed |
| Duty-Cycle Distortion   |        < 5% |
| Gating/Ungating Latency |   ≤ 1 cycle |
| Setup Violations        |           0 |
| Hold Violations         |           0 |
| Negative Slack          |           0 |

These requirements are specified in the official VELTRAXX'26 PS01 problem statement.

---

## 💻 Tools & Technologies

* **HDL:** SystemVerilog
* **Simulation:** Cadence Xcelium
* **Waveform Analysis:** Cadence Xcelium / GTKWave
* **Synthesis:** Cadence Genus
* **Static Timing Analysis:** Cadence Tempus
* **Constraints:** SDC
* **Version Control:** Git & GitHub

---

## 📁 Repository Structure

```text
PS01-Clock-Gating-Controller/
│
├── README.md
│
├── src/
│   └── low_power_soc.sv
│
├── tb/
│   └── tb_low_power_soc.sv
│
├── constraints/
│   └── clock_gating.sdc
│
├── scripts/
│   ├── simulation/
│   └── synthesis/
│
├── logs/
│   ├── simulation/
│   └── synthesis/
│
├── outputs/
│   ├── waveforms/
│   ├── netlist/
│   └── timing_reports/
│
├── docs/
│   ├── block_diagram/
│   ├── architecture/
│   └── final_report/
│
└── presentation/
    └── VELTRAXX26_PS01_Presentation.pptx
```

---

## 📄 RTL Source

The main RTL implementation is located at:

```text
src/low_power_soc.sv
```

The module is:

```systemverilog
module low_power_soc
```

The design is parameterized using:

```systemverilog
parameter int SYNC_STAGES = 2
```

---

## 📦 Required Deliverables

The final repository will contain:

* Parameterized synthesizable RTL
* Self-checking verification testbench
* Simulation waveform dumps
* SDC constraint file
* Synthesis scripts
* Synthesis reports
* Timing reports
* Area reports
* Documentation
* Final presentation

The official PS01 specifically requires parameterized synthesizable RTL, comprehensive verification, waveform evidence, and synthesis/timing reports.

---

## 🏆 Expected Outcome

The expected outcome is a robust **low-power clock-gating controller** suitable for mobile SoC applications.

The completed design should demonstrate:

* Correct clock gating
* Correct clock ungating
* Safe asynchronous wake-up handling
* Glitch-free clock operation
* Reduced unnecessary clock switching
* Correct operation of multiple functional blocks
* Successful RTL simulation
* Successful synthesis
* Timing closure with zero negative slack

---

## 👥 Project Information

**Event:** VELTRAXX'26
**Problem Statement:** PS 01
**Project:** Low-Power Clock Gating Controller for Mobile SoC
**Domain:** RTL-to-GDSII (ASIC Flow)

---

## 📜 License

Developed as part of the VELTRAXX'26 technical challenge.
