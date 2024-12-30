## Music interatice games

## Overview

A music interatice games project

# Project Overview

This project consists of various modules and files organized into different directories. Below is a brief description of each directory and its contents:

## Directory Structure
```
.
├── image_converter.py
├── kmeans_4bit_binary-1.bin
├── led
│   ├── led.v
│   ├── led.v.bak
│   ├── oscillator.v
│   ├── oscillator.v.bak
│   ├── player.v
│   ├── player.v.bak
│   ├── tb_ws2812b.v
│   ├── ws2812b.v
│   └── ws2812b.v.bak
├── picture
│   ├── background.jpg
│   ├── circle.png
│   ├── circle1.sv
│   ├── circle1.sv.bak
│   ├── circle2.sv
│   ├── circle2.sv.bak
│   ├── circle3.sv
│   ├── circle4.sv
│   ├── circle5.sv
│   ├── number
│   │   ├── 0.sv
│   │   ├── 1.sv
│   │   ├── 2.sv
│   │   ├── 3.sv
│   │   ├── 4.sv
│   │   ├── 5.sv
│   │   ├── 6.sv
│   │   ├── 7.sv
│   │   ├── 8.sv
│   │   └── 9.sv
│   └── score.sv
├── pll
│   ├── pll.bsf
│   ├── pll.cmp
│   ├── pll.html
│   ├── pll.xml
│   ├── pll_bb.v
│   ├── pll_generation.rpt
│   ├── pll_inst.v
│   ├── pll_inst.vhd
│   └── synthesis
│       ├── pll.debuginfo
│       ├── pll.qip
│       ├── pll.v
│       └── submodules
│           ├── altera_reset_controller.sdc
│           ├── altera_reset_controller.v
│           ├── altera_reset_synchronizer.v
│           └── pll_altpll_0.v
├── readme
├── rs232_qsys
│   ├── rs232.bsf
│   ├── rs232.cmp
│   ├── rs232.html
│   ├── rs232.xml
│   ├── rs232_bb.v
│   ├── rs232_generation.rpt
│   ├── rs232_generation_previous.rpt
│   ├── rs232_inst.v
│   ├── rs232_inst.vhd
│   └── synthesis
│       ├── Chain3.cdf
│       ├── rs232.debuginfo
│       ├── rs232.qip
│       ├── rs232.v
│       └── submodules
│           ├── RS232_wrapper.sv
│           ├── Rsa256Core.sv
│           ├── Rsa256Wrapper.sv
│           ├── altera_merlin_master_translator.sv
│           ├── altera_merlin_slave_translator.sv
│           ├── altera_reset_controller.sdc
│           ├── altera_reset_controller.v
│           ├── altera_reset_synchronizer.v
│           ├── rs232_altpll_0.v
│           ├── rs232_mm_interconnect_0.v
│           └── rs232_uart_0.v
└── src
    ├── DE2_115.sdc
    ├── DE2_115.sdc.bak
    ├── DE2_115.sv
    ├── DE2_115.sv.bak
    ├── Debounce.sv
    ├── RS232
    │   └── RS232_wrapper.sv
    ├── Rsa256Core.sv
    ├── Rsa256Wrapper.sv
    ├── SRAM
    │   ├── ColorDecoder.sv
    │   ├── SramAddrEncoder.sv
    │   └── SramDataDecoder.sv
    ├── SevenHexDecoder.sv
    ├── VGA
    │   ├── background_map.sv
    │   ├── vga.sv
    │   ├── vga_sram.sv
    │   └── vga_sram.sv.bak
    ├── core.sv
    └── position_handle.v
```
## Directory Descriptions

- **rs232_qsys**: Contains the Qsys files for the RS232 module.
- **src**: Contains the RS232 wrapper, SRAM module, VGA module, and DE2115 top module.
- **pll**: Contains PLL files.
- **picture**: Contains picture files like symbols or scores (written in Verilog).
- **led**: Contains the LED control module.

Each directory contains various Verilog and SystemVerilog files that implement the respective modules and functionalities.

## How to Run the Code

1. **Create a virtual environment using conda:**

   ```sh
   conda create --name camera python=3.10
   conda activate camera
   ```

2. **Install packages:**

   ```sh
   pip install -r requirements.txt
   ```
3. Burn the `kmeans_4bit_binary-1.bin` file into SRAM.
4. Add all files and compile the project.
5. After burning the compiled project into the FPGA
6. Run image_converter.py
Then, it is ready to use.

## To-Do List

- [x] 1. Camera
- [x] 2. RSA232
- [x] 3. VGA
- [x] 4. Light Controll
- [x] 5. Music Player
