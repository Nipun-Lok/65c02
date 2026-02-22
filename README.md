# 🖥️ 65c02
An 8-bit breadboard computer based on the Western Design Centre 65c02 microprocessor.
This repository tracks my progress in digital circuit design, assembly and computer architecture design. The project is based on Ben Eater's course [Build a 6502 computer](https://eater.net/6502).

## 🧩 Components
Most hardware components can be purchased from commercial suppliers such as [Mouser](https://au.mouser.com/), [CoreElectronics](https://core-electronics.com.au/) and [Digikey](https://www.digikey.com.au/). All required software is open source.

### ⚙️ Hardware
| Component | Source | Approx Price (AUD) |
| :--- | :--- | :--- |
| 65c02 Microprocessor<br>W65C02S6TPG-14 | Mouser | $17.66 |
| 65c22 Versatile Interface adapter<br>W65C22S6TPG-14 | Mouser | $17.97 |
| 65c51 Asynchronous Communication Interface Adapter (ACIA)<br>W65C51N6TPG-14| Mouser | $13.95 |
| 256Kb 32K x 8-bit paged SRAM<br>AS6C62256-55PCN| Mouser | $9.20 |
| 256Kb 32K x 8-bit paged EEPROM<br>AT28C256-15PU | Digikey | $18.37 |
| RS-232 transceiver<br>MAX232EIN  | Digikey | $2.97 |
| Quad 2-input NAND gate<br>74HC00  |  |  |
| 1MHz Can crystal oscillator <br>MXO45-3C-1M000000  | Digikey | $5.63 |
| 1.8432MHz Can crystal oscillator (passive)<br>AB-1.8432MHZ-B2| Digikey | $2.28 |
| DB9 female-to-terminal adapter<br>3122 | Digikey | $4.66 |
| 16POS 2.54mm header pins<br>10129378-916001BLF | Digikey | $0.47 |
| DFRobotics 1602 LCD<br>FIT0127 | Mouser | $15.20 |
| XGecu T48 Universal Programmer | Aliexpress XGecu Official Store | $68.14 |

### 💾 Software
There are two assembler platforms used in this project:
- [VASM](http://sun.hasenbraten.de/vasm/): A simple lightweight assembler with optomisation capabilities. This is run in the terminal using:
```bash
    vasm6502_oldstyle -Fbin -dotdir -o filename.s filename.bin
```
- [cc65 cross-compiler suite](https://github.com/cc65/cc65): A development package consisting of a macro assembler, linker, C compiler and more. Linker requires a `.cfg` file for segment mapping. This is run using:
```bash
    ca65 --cpu W65C02 filename.s -l filename.lst
    ld65 -C filename.cfg filename.o -m main.map
```

- (Optional) [minipro](https://gitlab.com/DavidGriffith/minipro): A terminal program for programming EEPROMs with the XGecu T48 on Unix systems such as macOS and Linux. This is run using:
```bash
    minipro -p "AT28C256" -w filename.bin
```
- Throughout this project several `build.sh`/`Makefile` files may be made to streamline this process. Current options include:
```bash
    ./vasm.sh source.s
```
```bash
    ./cc65.sh source1.s source2.s linker.cfg
```

- Both build scripts compile a single `main.bin` file. The later also outputs listing files for each source file and a map file for the final binary.

### 🔩 Additional Requirements
Possession of standard off-the-shelf electronics components such as resistors, potentiometers, diodes, capacitors and breadboards (at least 3 required) are assumed.
