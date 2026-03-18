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

- (Optional) [minipro](https://gitlab.com/DavidGriffith/minipro): A terminal program for programming EEPROMs with the XGecu T48 on Unix systems such as macOS and Linux. Windows users may opt to use the provided application for writing binaries to the EEPROM. Otherwise this shell script is run using:
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
Possession of standard off-the-shelf electronics components such as resistors, potentiometers, diodes, capacitors and breadboards (at least 3 required) are assumed. Basic knowledge of electrical circuits, and digital circuit concepts are assumed. Further self-learning is encouraged and suggestions will be made along the course of the project.

### 🧠 What is a Computer
Computers are in essence a high level abstraction of a calculator which as the name implies, allows it to compute a result, perform a task, conform to a predetermined behaviour. Building such a complex machine is near impossible to do on first principles alone. As with many fields of computer science the problem can be greatly simplified with abstraction.

We will consider a computer to be a device that can be configured to read in input, store it, process it and return an output. The principle components of a computer include:
- Processor:
    - This is the main component that speaks only in binary and yet coordinates the whole orchestra
    - It performs the arithmetic and logical operations and synchronises the system.
- Clock:
    - This is the heartbeat of the computer fundamentally determining its speed, compatible auxiliaries and reliability.
- Memory:
    - This is scratch pad the computer uses as instructions
- Input/Output (I/O) interface
    - How we interact with the computer

For each principle component there are many options/design choices one can make or be forces into by the nature of the other components. As with any engineering project, components must be selected with their trade-offs and benefits in mind. 

The computer we will build is classed as a Von Neumann architecture. This means the addressible space is shared by both the I/O interface and memory. This is not as efficient as the Harvard architecture which maintains two separate busses for I/O and memory. This distinction will be made clear in the design of the memory map. Von Neumann systems are very simple and are much more approachable as an introduction to computer design.

### 🧮 The Processor

The processor (65C02) has two busses it uses to communicate with the outside world. These are the address bus and the data bus. 
The processor (65C02) has several internal registers to coordinate interactions with all external connections. One may visualise these registers as digital buckets that can be filled up and drained (written to), or observed (read from). The available registers include:
- Accumulator: This is the standard results bucket which is used for interfacing with the databus and performing logical operations.