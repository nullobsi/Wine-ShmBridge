# Where Wine is installed to
WINE_DIR ?= /usr/local
# Include directory: contains wine/unixlib.h
WINE_INCLUDE_DIR ?= $(WINE_DIR)/include

# Windows vs UNIX C compiler
MINGW_CC ?= x86_64-w64-mingw32-gcc
NATIVE_CC ?= gcc
VERSION ?= 0.0.1
CFLAGS ?= -O2 -Wall -Wextra
LDFLAGS ?=

WINE_INCLUDE = -I"$(WINE_INCLUDE_DIR)"

.PHONY: all windows native clean
.DELETE_ON_ERROR:
all: windows native
windows: shmbridge.dll
native: shmbridge.so

shmbridge.dll: shmbridge-win.c unix_lib.c version.c version.h common.h shmbridge.def
	$(MINGW_CC) -std=gnu17 $(CFLAGS) $(WINE_INCLUDE) \
		-D__WINE_PE_BUILD -D__WINESRC__ -DWIN32_LEAN_AND_MEAN -DVERSION_INFO='"$(VERSION)"' -shared \
		shmbridge-win.c version.c unix_lib.c shmbridge.def \
		$(LDFLAGS) -Wl,--exclude-all-symbols -lntdll -o $@
	# Mark the PE as a Wine builtin, as winebuild --builtin does.
	printf 'Wine builtin DLL\0' | dd of=$@ bs=32 seek=2 conv=sync,notrunc

# Wine uses the .so suffix even though this is a Mach-O dynamic library.
shmbridge.so: shmbridge-unix.c common.h posix-macos-sem-timedwait.h
	$(NATIVE_CC) -arch x86_64 -std=gnu17 $(CFLAGS) $(WINE_INCLUDE) \
		-DWINE_UNIX_LIB -fPIC -fshort-wchar -fvisibility=hidden -shared \
		shmbridge-unix.c $(LDFLAGS) -o $@

clean:
	rm -f shmbridge.dll shmbridge.so
