````markdown
# VELTRAXX'26 – PS 01

## Low-Power Clock Gating Controller for Mobile SoC

### Problem Statement

Design and verification of a low-power clock gating controller for a mobile SoC.

The objective of this project is to reduce unnecessary dynamic power consumption by disabling the clock supplied to inactive functional blocks. The design also handles asynchronous wake-up requests and provides safe clock gating and ungating operation.

**Focused Domain:** RTL-to-GDSII (ASIC Flow)

---

## Project Overview

In a mobile SoC, different functional blocks may not be active at the same time. If the clock continues to operate for inactive blocks, unnecessary switching activity occurs and dynamic power is consumed.

This project implements a clock gating controller that provides individual gated clocks for multiple functional blocks.

The current design supports:

- CPU
- SRAM
- GPIO
- Timer
- UART

The design also supports asynchronous wake-up and test/scan enable functionality.

---

## Objectives

- Reduce unnecessary clock switching activity.
- Reduce dynamic power consumption.
- Provide individual clock control for SoC functional blocks.
- Safely handle asynchronous wake-up requests.
- Generate glitch-free gated clock signals.
- Support test/scan enable operation.
- Implement synthesizable SystemVerilog RTL.
- Verify the design using a testbench.
- Perform synthesis and timing analysis as part of the ASIC flow.

---

## Design Features

- Individual clock gating for CPU, SRAM, GPIO, Timer and UART.
- Asynchronous wake-up synchronizer.
- Parameterized synchronizer stages.
- Negative-edge based clock-enable latching.
- Gated clock generation.
- Test/scan enable support.
- Activity counters for observing clock activity.
- Active-low reset.
- Synthesizable SystemVerilog RTL.

---

## Functional Blocks

| Functional Block | Enable Signal | Gated Clock |
|---|---|---|
| CPU | `cpu_enable` | `cpu_clk` |
| SRAM | `sram_enable` | `sram_clk` |
| GPIO | `gpio_enable` | `gpio_clk` |
| Timer | `timer_enable` | `timer_clk` |
| UART | `uart_enable` | `uart_clk` |

---

## Inputs

| Signal | Description |
|---|---|
| `clk` | Global system clock |
| `rst_n` | Active-low reset |
| `cpu_enable` | CPU clock enable |
| `sram_enable` | SRAM clock enable |
| `gpio_enable` | GPIO clock enable |
| `timer_enable` | Timer clock enable |
| `uart_enable` | UART clock enable |
| `async_wakeup` | Asynchronous wake-up request |
| `test_enable` | Test/scan enable |

---

## Outputs

| Signal | Description |
|---|---|
| `cpu_clk` | Gated CPU clock |
| `sram_clk` | Gated SRAM clock |
| `gpio_clk` | Gated GPIO clock |
| `timer_clk` | Gated Timer clock |
| `uart_clk` | Gated UART clock |
| `wake_sync` | Synchronized wake-up signal |

---

## Clock Gating Operation

The clock enable for each functional block is generated using the corresponding functional enable, synchronized wake-up signal and test enable.

The general control logic is:

```text
Gate Enable = Functional Enable OR Wake-Up OR Test Enable
````

For example, the CPU clock gate enable is generated as:

```systemverilog
assign cpu_gate_en =
        cpu_enable |
        wake_sync  |
        test_enable;
```

The same control method is used for SRAM, GPIO, Timer and UART.

---

## Asynchronous Wake-Up

The `async_wakeup` signal is asynchronous to the main system clock.

A configurable multi-stage synchronizer is used to synchronize the wake-up signal.

The number of synchronization stages is controlled using:

```systemverilog
parameter int SYNC_STAGES = 2
```

The synchronized wake-up signal is available through:

```text
wake_sync
```

The synchronized signal is then used for clock enable generation.

---

## Glitch-Free Clock Gating

The clock enable signals are latched on the negative edge of the main clock before generating the gated clock.

Example:

```systemverilog
always_ff @(negedge clk or negedge rst_n) begin
    if (!rst_n)
        cpu_en_latched <= 1'b0;
    else
        cpu_en_latched <= cpu_gate_en;
end
```

The gated clock is generated using:

```systemverilog
assign cpu_clk = clk & cpu_en_latched;
```

The same approach is applied to the other functional blocks.

This approach is used to avoid unwanted clock glitches and runt pulses during clock gating.

---

## Activity Monitoring

The design contains activity counters for the global clock and individual functional blocks.

The counters are used during simulation to observe the clock activity of each block.

Activity monitoring is provided for:

* CPU
* SRAM
* GPIO
* Timer
* UART

---

## Verification

The verification environment contains SystemVerilog testbench files for checking the clock gating controller.

The verification covers:

* Reset operation
* Clock enable operation
* Clock disable operation
* Individual functional block clock gating
* Multiple block enable operation
* Asynchronous wake-up
* Test/scan enable
* Gated clock behavior
* Activity counter behavior
* Boundary and corner cases

Waveform analysis will be used to verify clock transitions and gating behavior.

---

## PS01 Requirements

The project is developed according to the requirements of VELTRAXX'26 PS01.

| Requirement              | Target          |
| ------------------------ | --------------- |
| Asynchronous Wake-Up     | Supported       |
| Glitch-Free Clock Gating | Required        |
| Runt Pulses              | Not allowed     |
| Duty-Cycle Distortion    | < 5%            |
| Gating/Ungating Latency  | ≤ 1 clock cycle |
| Setup Violations         | 0               |
| Hold Violations          | 0               |
| Negative Slack           | 0               |

---

## Repository Structure

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
│
└── presentation/
```

---

## Source Files

### `src/clock_gating_controller.sv`

Contains the main clock gating controller RTL implementation.

### `src/design.sv`

Contains the supporting design-level RTL used in the project.

---

## Testbench Files

The verification files are maintained under the `tb` directory.

### `tb/interface.sv`

Contains the interface definitions used by the verification environment.

### `tb/pkg.sv`

Contains the package definitions used by the testbench.

### `tb/tb.sv`

Contains the main testbench environment.

### `tb/tb_clock_gating_controller.sv`

Contains the testbench for the clock gating controller.

---

## Tools Used

* SystemVerilog
* Cadence Xcelium
* GTKWave
* Cadence Genus
* Cadence Tempus
* SDC
* Git
* GitHub

---

## ASIC Flow

The project follows the basic RTL-to-GDSII flow:

```text
RTL Design
    |
    v
Functional Verification
    |
    v
Simulation
    |
    v
Synthesis
    |
    v
Static Timing Analysis
    |
    v
Area / Power Analysis
```

---

## Output Directory

Simulation and implementation results will be maintained under the `outputs` directory.

```text
outputs/
│
├── waveforms/
├── netlist/
└── timing_reports/
```

### Waveforms

Simulation waveform files will be stored under:

```text
outputs/waveforms/
```

### Netlist

Synthesis-generated netlists will be stored under:

```text
outputs/netlist/
```

### Timing Reports

Static timing analysis reports will be stored under:

```text
outputs/timing_reports/
```

---

## Constraints

Timing constraints for the design will be maintained under:

```text
constraints/
```

The SDC file will define the clock and timing requirements required for synthesis and static timing analysis.

---

## Scripts

Automation scripts for simulation and synthesis will be maintained under:

```text
scripts/
├── simulation/
└── synthesis/
```

---

## Logs

Execution logs will be maintained separately for simulation and synthesis.

```text
logs/
├── simulation/
└── synthesis/
```

---

## Current Status

* [x] Project repository created
* [x] README added
* [x] RTL source files added
* [x] Testbench files added
* [ ] Functional simulation
* [ ] Waveform verification
* [ ] SDC constraints
* [ ] RTL synthesis
* [ ] Synthesis reports
* [ ] Static timing analysis
* [ ] Timing reports
* [ ] Area analysis
* [ ] Power analysis

---

## Expected Outcome

The final implementation is expected to demonstrate a functional low-power clock gating controller capable of safely controlling the clocks of multiple mobile SoC functional blocks.

The completed project will be evaluated for:

* Correct clock gating
* Correct clock ungating
* Asynchronous wake-up handling
* Glitch-free operation
* Runt-pulse prevention
* Duty-cycle integrity
* Gating and ungating latency
* Timing closure
* Area
* Power consumption

---

## Problem Statement

**VELTRAXX'26 – Problem Statement 01**

**Title:** Low-Power Clock Gating Controller for Mobile SoC

**Domain:** RTL-to-GDSII (ASIC Flow)

---

## Team

**VELTRAXX'26 – PS 01**

Low-Power Clock Gating Controller for Mobile SoC

---

## License

This project is developed as part of the VELTRAXX'26 technical challenge.

```
```
