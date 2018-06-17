RM       = rm -f
AR       = ar

prefix    ?= /usr/local
bindir     = $(prefix)/bin
libexecdir = $(prefix)/lib/jgmenu

ifeq ($(prefix),$(HOME))
datarootdir= $(prefix)/.local/share
else
datarootdir= $(prefix)/share
endif

CFLAGS  += -g -Wall -Os -std=gnu89
CFLAGS  += -Wextra -Wdeclaration-after-statement -Wno-format-zero-length \
	   -Wold-style-definition -Woverflow -Wpointer-arith \
	   -Wstrict-prototypes -Wunused -Wvla -Wunused-result
CFLAGS  += -Wno-unused-parameter
CFLAGS  += -DVERSION='"$(VER)"'

jgmenu:     CFLAGS  += `pkg-config cairo pango pangocairo librsvg-2.0 --cflags`
jgmenu-ob:  CFLAGS  += `xml2-config --cflags`
jgmenu-xdg: CFLAGS  += `xml2-config --cflags`

jgmenu:     LIBS += `pkg-config x11 xinerama cairo pango pangocairo librsvg-2.0 --libs`
jgmenu:     LIBS += -pthread -lrt -lpng
jgmenu-ob:  LIBS += `xml2-config --libs`
jgmenu-xdg: LIBS += `xml2-config --libs`

LDFLAGS += $(LIBS)

ifdef ASAN
ASAN_FLAGS = -O0 -fsanitize=address -fno-common -fno-omit-frame-pointer -rdynamic
CFLAGS    += $(ASAN_FLAGS)
LDFLAGS   += $(ASAN_FLAGS) -fuse-ld=gold
endif

ifndef VERBOSE
QUIET_CC   = @echo '     CC    '$@;
QUIET_LINK = @echo '     LINK  '$@;
QUIET_AR   = @echo '     AR    '$@;
endif

