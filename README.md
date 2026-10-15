# Wine Shared Memory Bridge

This library is a wrapper that exposes shared memory structures (such as semaphores) to programs running within Wine.

This lets the programmer interface more directly with programs running within Wine via shared memory.

## Building

Check the GitHub Actions file for a detailed guide on building the
library. In particular, a WINE development environment is needed with
`winegcc` and a proper `mingw-w64` compiler. Building is done with a
Makefile. The Makefile contains 4 targets:

- `wine` builds a PE DLL for use with WINE versions >= 11.2 without
  special shenanigans.
- `wine-builtin` builds a PE DLL marked as a WINE built-in for use with
  WINE versions < 11.2. This requires the directory with the DLL to be
  added to the `WINEDLLPATH` environment variable.
- `native-linux` and `native-osx` build the same `.so` file but with a
  different name. This reduces ambiguity as the filename also denotes
  which platform it was built for.


# To-Do

- [x] Semaphores
- [ ] Memory-mapped files
