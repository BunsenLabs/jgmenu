#
# Define ASAN=1 to enable AddressSanitizer
#
# Define VERBOSE=1 for a more verbose compilation
#

VER      = $(shell git describe 2>/dev/null)
CC       = gcc
LD       = gcc
MAKE     = make

prefix   = $(HOME)
bindir   = $(prefix)/bin

CFLAGS   = -g -Wall -Os
CFLAGS  += -DVERSION='"$(VER)"'
CFLAGS  += -DXINERAMA
CFLAGS  += `pkg-config cairo pango pangocairo librsvg-2.0 --cflags`
CFLAGS  += `pkg-config gtk+-3.0 --cflags`
CFLAGS  += `xml2-config --cflags`

LIBS  = `pkg-config x11 xinerama cairo pango pangocairo librsvg-2.0 --libs`
LIBS += `pkg-config gtk+-3.0 --libs`
LIBS += `xml2-config --libs`
LIBS += -pthread

LDFLAGS  = $(LIBS)

ifdef ASAN
ASAN_FLAGS = -O0 -fsanitize=address -fno-common -fno-omit-frame-pointer -rdynamic
CFLAGS    += $(ASAN_FLAGS)
LDFLAGS   += $(ASAN_FLAGS)
endif

SCRIPTS  = jgmenu_run jgmenu-cache
PROGS	 = jgmenu jgmenu-xdg jgmenu-icon-find

LIB_H = $(shell find . -name '*.h' -print)
OBJS =  x11-ui.o config.o util.o geometry.o isprog.o sbuf.o icon-find.o icon.o \
        xdgdirs.o xdgapps.o 

ifndef VERBOSE
QUIET_CC	= @echo '   ' CC $@;
QUIET_LINK	= @echo '   ' LINK $@;
endif

all: $(PROGS)

jgmenu: jgmenu.c $(OBJS)
	$(QUIET_LINK)$(LD) $(CFLAGS) -o jgmenu jgmenu.c $(OBJS) $(LDFLAGS)

jgmenu-xdg: xdgmenu.c $(OBJS)
	$(QUIET_LINK)$(LD) $(CFLAGS) -o jgmenu-xdg xdgmenu.c $(OBJS) $(LDFLAGS)

jgmenu-icon-find: jgmenu-icon-find.c $(OBJS)
	$(QUIET_LINK)$(LD) $(CFLAGS) -o jgmenu-icon-find jgmenu-icon-find.c $(OBJS) $(LDFLAGS)

%.o: %.c $(LIB_H)
	$(QUIET_CC)$(CC) $(CFLAGS) $(LIBS) -c $*.c

install: $(PROGS) $(SCRIPTS)
	@install -d $(DESTDIR)$(bindir)
	@install -m755 $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)

clean:
	@rm -f $(PROGS) *.o

test:
	@$(MAKE) --no-print-directory -C tests/ all

ex:
	@$(MAKE) --no-print-directory -C examples/ all
