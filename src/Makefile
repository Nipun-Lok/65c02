# Assembly compilers for 65c02 breadboard computer
SRC = $(filter %.s, $(MAKECMDGOALS))
CFG = $(filter %.cfg, $(MAKECMDGOALS))

OUT = main.bin
OBJ = $(SRC:.s=.o)
INC = $(wildcard *.inc)

.PHONY vasm cc65 clean

vasm: $(OUT)
cc65: $(OUT)

ifeq ($(firstword $(MAKECMDGOALS)),vasm)

$(OUT): $(SRC) $(INC)
	@echo "Building $@"
	vasm6502_oldstyle -Fbin -dotdir -o $@ $<

endif

ifeq ($(firstword $(MAKECMDGOALS)),cc65)

%.o: %.s $(INC)
	@echo "Compiling $< into $@"
	ca65 --cpu W65C02 $< -o $@ -l $*.lst

$(OUT): $(OBJ) $(CFG)
	@echo "Linking into $@..."
	ld65 -C $(CFG) $(OBJ) -o $@

endif

clean:
	rm -f *.o *.bin *.lst
