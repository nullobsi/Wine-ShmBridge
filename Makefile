# Where Wine is installed to
WINE_DIR ?= /usr
# Include directory: contains wine/unixlib.h
WINE_INCLUDE_DIR ?= $(WINE_DIR)/include

# Windows vs UNIX C compiler
WINE_CC ?= $(WINE_DIR)/bin/winegcc
NATIVE_CC ?= cc
VERSION ?= 0.0.1
CFLAGS ?= -O2 -Wall -Wextra
LDFLAGS ?=

WINE_INCLUDE = -I"$(WINE_INCLUDE_DIR)"

.PHONY: all windows native clean
.DELETE_ON_ERROR:
all: windows windows-compat native
windows: shmbridge.dll
windows-compat: shmbridge-compat.dll
native: shmbridge.so

shmbridge.dll: shmbridge-win.c version.c version.h common.h shmbridge.def
	$(WINE_CC) -shared -std=gnu17 $(CFLAGS) $(WINE_INCLUDE) \
		-D__WINE_PE_BUILD -D__WINESRC__ -DWIN32_LEAN_AND_MEAN -DVERSION_INFO='"$(VERSION)"' \
		shmbridge-win.c version.c unix_lib.c shmbridge.def \
		$(LDFLAGS) \
		-o $@

shmbridge-compat.dll: shmbridge-win.c version.c version.h common.h shmbridge.def
	$(WINE_CC) -shared -std=gnu17 $(CFLAGS) $(WINE_INCLUDE) \
		-DSHMBRIDGE_WINE_COMPAT -D__WINE_PE_BUILD -D__WINESRC__ -DWIN32_LEAN_AND_MEAN -DVERSION_INFO='"$(VERSION)"' \
		shmbridge-win.c version.c unix_lib.c shmbridge.def \
		-Wl,--wine-builtin $(LDFLAGS) \
		-o $@

# Wine uses the .so suffix, even on macOS.
shmbridge.so: shmbridge-unix.c common.h posix-macos-sem-timedwait.h
	$(NATIVE_CC) -shared -std=gnu17 $(CFLAGS) $(WINE_INCLUDE) \
		-fPIC -fshort-wchar -fvisibility=hidden \
		shmbridge-unix.c  \
		$(LDFLAGS)  \
		-o $@

clean:
	rm -f shmbridge.dll shmbridge.so shmbridge-compat.dll
