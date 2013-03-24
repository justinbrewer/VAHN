SAHN_VERSION = 0.2.1

CC = gcc
CFLAGS = -c -Isrc -Ilib
debug : CFLAGS += -g -O0

LL = gcc
LFLAGS = -Wl,-rpath,lib -Llib -lsahn$(D) -lasound

OBJDIR = obj

OBJ = $(OBJDIR)/main.o

debug : D = _d


all: lib/libsahn.so $(OBJDIR) vahn

debug: lib/libsahn_d.so $(OBJDIR) vahn

$(OBJDIR):
	@mkdir -p $(OBJDIR)

lib/libsahn.so:
	@$(MAKE) -C lib/sahn dist
	@mv lib/sahn/libsahn-$(SAHN_VERSION)/libsahn.so lib/sahn/libsahn-$(SAHN_VERSION)/sahn.h lib

lib/libsahn_d.so:
	@$(MAKE) -C lib/sahn debug
	@cp lib/sahn/sahn/sahn.h lib
	@mv lib/sahn/bin/libsahn_d.so lib

clean:
	@$(MAKE) -C lib/sahn clean
	@rm -rf $(OBJDIR) vahn lib/sahn.h lib/libsahn.so lib/libsahn_d.so

vahn: $(OBJ)
	$(LL) $(LFLAGS) -o vahn $(OBJ)

$(OBJDIR)/main.o: src/main.c
	$(CC) $(CFLAGS) -o $(OBJDIR)/main.o src/main.c
