EXE = start.o
EXE_SO = libmini.so
OBJ_DIR = obj

SOURCES = libmini64.asm libmini.c start.asm
OBJS_LIB = $(addprefix $(OBJ_DIR)/, $(addsuffix .o, $(basename $(notdir $(filter lib%, $(SOURCES))))))
OBJS_START = $(addprefix $(OBJ_DIR)/, $(addsuffix .o, $(basename $(notdir $(filter start%, $(SOURCES))))))

ASMFLAGS = -f elf64 -DYASM -D__x86_64__ -DPIC
CFLAGS = -g -Wall -fno-stack-protector -fPIC -nostdlib
LDFLAGS = -shared

all: create_object_directory $(EXE) $(EXE_SO)
	@echo Compile Success

create_object_directory:
	mkdir -p $(OBJ_DIR)

$(OBJ_DIR)/%.o: %.asm
	yasm ${ASMFLAGS} -o $@ $<

$(OBJ_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(EXE): $(OBJS_START)
	cp $< $@

$(EXE_SO): $(OBJS_LIB)
	ld $(LDFLAGS) -o $@ $<

clean:
	rm -rf $(OBJ_DIR) $(EXE) $(EXE_SO)
