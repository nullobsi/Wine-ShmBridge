# Where Wine is installed to
WINE_DIR ?= /usr
# Include directory: contains wine/unixlib.h
WINE_INCLUDE_DIR ?= $(WINE_DIR)/include

# These can be changed if needed.
SHMBRIDGE_SO_LINUX ?= shmbridge-linux.so
# Windows vs UNIX C compiler
WINE_CC ?= $(WINE_DIR)/bin/winegcc
MINGW_CC ?= x86_64-w64-mingw32
NATIVE_CC ?= cc
VERSION ?= 0.0.1
CFLAGS ?= -O2 -Wall -Wextra
LDFLAGS ?=

SHMBRIDGE_SO_LINUX_DEFINE = -DSHMBRIDGE_TARGET_SO='L"$(SHMBRIDGE_SO_LINUX)"'
WINE_INCLUDE = -I"$(WINE_INCLUDE_DIR)" -I"$(WINE_INCLUDE_DIR)/wine/windows"

.PHONY: all windows native clean
.DELETE_ON_ERROR:
all: wine-builtin native-linux
wine-builtin: shmbridge-builtin.dll
wine-linux: shmbridge-linux.dll
native-linux: shmbridge-linux.so

shmbridge-linux.dll: shmbridge-win.c version.c version.h common.h shmbridge.def
	$(WINE_CC) -b $(MINGW_CC) -shared -std=gnu17 $(CFLAGS) $(WINE_INCLUDE) \
		-D__WINE_PE_BUILD -D__WINESRC__ -DWIN32_LEAN_AND_MEAN -DVERSION_INFO='"$(VERSION)"' $(SHMBRIDGE_SO_LINUX_DEFINE) \
		shmbridge-win.c version.c shmbridge.def \
		$(LDFLAGS) \
		-o $@

shmbridge-builtin.dll: shmbridge-win.c version.c version.h common.h shmbridge.def
	$(WINE_CC) -b $(MINGW_CC) -shared -std=gnu17 $(CFLAGS) $(WINE_INCLUDE) \
		-DSHMBRIDGE_WINE_COMPAT -D__WINE_PE_BUILD -D__WINESRC__ -DWIN32_LEAN_AND_MEAN -DVERSION_INFO='"$(VERSION)"' \
		shmbridge-win.c version.c shmbridge.def \
		-Wl,--wine-builtin $(LDFLAGS) \
		-o $@

shmbridge-linux.so: shmbridge-unix.c common.h
	$(NATIVE_CC) -shared -std=gnu17 $(CFLAGS) $(WINE_INCLUDE) \
		-fPIC -fshort-wchar -fvisibility=hidden \
		shmbridge-unix.c  \
		$(LDFLAGS)  \
		-o $@

clean:
	rm -f shmbridge.dll shmbridge.so shmbridge-compat.dll
