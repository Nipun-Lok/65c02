# 65c02
An 8-bit breadboard computer based on the Western Design Centre 65c02 microprocessor.
This repository tracks my progress in digital circuit design, assembly and computer architecture design. The project is based on Ben Eater's course [Build a 6502 computer](https://eater.net/6502).

## Components
Most hardware components can be purchased from commercial suppliers such as [Mouser](https://au.mouser.com/), [CoreElectronics](https://core-electronics.com.au/) and [Digikey](https://www.digikey.com.au/). All required software is open source.

### Hardware
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

### Software
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

### Additional Requirements
Possession of standard off-the-shelf electronics components such as resistors, potentiometers, diodes, capacitors and breadboards (at least 3 required) are assumed. Basic knowledge of electrical circuits, and digital circuit concepts are assumed. Further self-learning is encouraged and suggestions will be made along the course of the project.

### What is a Computer
Computers are in essence a high level abstraction of a calculator which as the name implies, allows it to compute a result, perform a task, conform to a predetermined behaviour. Building such a complex machine is near impossible to do on first principles alone. As with many fields of computer science the problem can be greatly simplified with abstraction.

We will consider a computer to be a device that can be configured to read in input, store it, process it and return an output. The principle components of a computer include:
- Processor:
    - This is the main component that speaks only in binary and yet coordinates the whole orchestra
    - It performs the arithmetic and logical operations through the ALU (Arithmetic and Logic Unit) and synchronises the system.
- Clock:
    - This is the heartbeat of the computer fundamentally determining its speed, compatible auxiliaries and reliability.
- Memory:
    - This is scratch pad the computer uses as instructions
- Input/Output (I/O) interface
    - How we interact with the computer

For each principle component there are many options/design choices one can make or be forces into by the nature of the other components. As with any engineering project, components must be selected with their trade-offs and benefits in mind. 

The design priorities for this project include simplicity at the cost of capability, gate cost, and compatibility with accessible components. You may and are encouraged to prioritizes other features/qualities if you wish.

### The Clock
The clock is a fundamental component of computers, development boards and microcontrollers which fall under the category of synchronous circuits. Internal operations carried out by the ALU are initiated by the rising or falling edge of the clock cycle. Every component interfacing with the processor is required to follow the strict timing rules on when shared resources are valid and how quickly they must respond. 

This signal is typically a square wave with an amplitude matching the logic level of the hardware and a consistent frequency in the range tolerable range as specified by the chip manufacturer. Frequency is a key parameter quantifing the computer's responsiveness and speed. This is often a limitation based on topology and material constraints.

Synchronous circuits typically involve edge-triggered components such as registers and flip flops. Capacitive lagging results in a response delay that must be tolerated by all connected components. If you wish to learn more about these fundamental functional blocks consider researching D latches, SR latches, bistable multivibrators. To see how these components are used in a CPU consider visiting [Ben Eater's 8-Bit Breadboard computer project](https://eater.net/8bit).

The 65C02 datasheet specifies a maximum validated clock speed dependent on the package version, however, due to the before mentioned capacitive lagging, the breadboard construction limits us to between 1-5MHz, well below this maximum. This project is not designed with maximum performance in mind and this limitation is compensated by retaining the ability to wire up each connection with full understand of how components are connected functionally and physically.

Regardless, it is quite difficult to visuallise how data is flowing throughout a program at these speeds. We will first run our processor on a variable speed clock that can be single stepped to watch each operation take place. 
The processor (65C02) has several internal registers to coordinate interactions with all external connections. One may visualise these registers as digital buckets that can be filled up and drained (written to), or observed (read from). The available registers include:
- Accumulator: This is the standard results bucket which is used for interfacing with the databus and performing logical operations.