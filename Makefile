#
# executable is named same as current directory
EXEC=pong
.SUFFIXES: .asm .o
SRCS=$(EXEC).asm
OBJS=$(subst .asm,.o, $(SRCS))
DEP_SRCS=$(wildcard ./lib/*.asm)
DEP_OBJS=$(subst .asm,.o, $(DEP_SRCS))

BITS:=32
ifeq ($(BITS),64)
NASM_FMT=elf64
LD_EMM=elf_x86_64
else
NASM_FMT=elf32
LD_EMM=elf_i386
endif

DBGI=dwarf

all: $(EXEC)

deps:
	wget --timestamping --directory-prefix=lib https://raw.githubusercontent.com/thlorenz/lib.asm/master/ansi_cursor_hide.asm
	wget --timestamping --directory-prefix=lib https://raw.githubusercontent.com/thlorenz/lib.asm/master/ansi_cursor_position.asm
	wget --timestamping --directory-prefix=lib https://raw.githubusercontent.com/thlorenz/lib.asm/master/ansi_cursor_show.asm
	wget --timestamping --directory-prefix=lib https://raw.githubusercontent.com/thlorenz/lib.asm/master/ansi_term_clear.asm
	wget --timestamping --directory-prefix=lib https://raw.githubusercontent.com/thlorenz/lib.asm/master/hex2decimal.asm
	wget --timestamping --directory-prefix=lib https://raw.githubusercontent.com/thlorenz/lib.asm/master/sys_nanosleep.asm
	wget --timestamping --directory-prefix=lib https://raw.githubusercontent.com/thlorenz/lib.asm/master/sys_signal.asm
	wget --timestamping --directory-prefix=lib https://raw.githubusercontent.com/thlorenz/lib.asm/master/sys_write_stdout.asm
	wget --timestamping --directory-prefix=lib https://raw.githubusercontent.com/thlorenz/lib.asm/master/signals.mac
	wget --timestamping --directory-prefix=lib https://raw.githubusercontent.com/thlorenz/log.mac/master/log.mac

deps-clean:
	rm -f $(DEP_OBJS)

realclean: deps-clean clean

gdb: clean $(EXEC)
	gdb -- $(EXEC)

.asm.o:
	nasm -f $(NASM_FMT) -g -F $(DBGI) $< -o $@

$(EXEC): $(OBJS) $(DEP_OBJS)
	ld -m $(LD_EMM) -o $@ $^

clean:
	rm -f $(OBJS) $(EXEC)

.PHONY: all clean deps deps-clean realclean gdb
