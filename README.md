# Wine Shared Memory Bridge

This library is a wrapper that exposes shared memory structures (such as semaphores) to programs running within Wine.

This lets the programmer interface more directly with programs running within Wine via shared memory.

## Building

Check the GitHub Actions file for a detailed guide on building the
library. In particular, a WINE development environment is needed with
`winegcc` and a proper `mingw-w64` compiler. Building is done with a
Makefile. The Makefile contains multiple targets:

- `native-linux` builds the native .so file that calls the POSIX
  semaphore API.
- `wine-builtin` builds a PE DLL marked as a WINE built-in for use with
  WINE versions < 11.2. This requires the directory with the DLL to be
  added to the `WINEDLLPATH` environment variable. 
- `wine-linux` both builds a PE DLL for use with WINE versions >= 11.2 without
  special shenanigans. 

## Usage
For WINE >= 11.2, the PE .DLL file automatically tries to load the
appropriately named .so file next to it. The .so file it tries to load
can be changed by setting the `SHMBRIDGE_SO_LINUX`
Makefile variable at compile-time. On Linux, this should be set to
`shmbridge-linux.so`.

For WINE < 11.2, the PE .DLL file is compiled and marked as a WINE
built-in. This means that the folder which contains it must be added to
the `WINEDLLPATH` environment variable, otherwise it will not be loaded.
In addition, a `.so` file with the same name must be present which WINE
attempts to load automatically. The following schemes work:

```
WINEDLLPATH/shmbridge-linux{.dll,.so}
```

or
```
WINEDLLPATH/x86_64-windows/shmbridge-linux.dll
WINEDLLPATH/x86_64-unix/shmbridge-linux.osx
```

Note that the `builtin` DLL files work on WINE >= 11.2 as well, however,
they maintain all the same limitations of needing to be placed in the
`WINEDLLPATH`. As WINE versions mature, the hope is that the newer
interface becomes more supported, such that the environment variable
hack is no longer needed.

# To-Do

- [x] Semaphores
- [ ] Memory-mapped files
