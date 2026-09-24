# Wine Shared Memory Bridge

This library is a wrapper that exposes shared memory structures (such as semaphores) to programs running within Wine.

This lets the programmer interface more directly with programs running within Wine via shared memory.

## Building on macOS

Requires MinGW-w64 (`x86_64-w64-mingw32-gcc`), Make, and the Wine header
files. Simply run `make` with the default target to build.

```sh
make
```

The default Wine header location is `/usr/local/include/wine`, and can
be overridden by setting `WINE_INCLUDE_DIR=/path/to/include/wine`. The Windows
build compiles Wine's `dlls/winecrt0/unix_lib.c` for Unixlib.

Binaries are built for x86_64:

- `shmbridge.dll`: Windows PE DLL, marked as a Wine builtin.
- `shmbridge.so`: Native Mach-O dylib. Wine requires the `.so` filename.

`make windows` and `make native` build the individual halves. `make clean`
deletes produced binaries. Use `make -B VERSION=1.2.3` to change the embedded
version, or `./Build.sh 1.2.3`. Compilers can be overridden with `MINGW_CC` and
`NATIVE_CC`. 

# To-Do

- [x] Semaphores
- [ ] Memory-mapped files
