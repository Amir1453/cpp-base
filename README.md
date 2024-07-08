# C++ Project Template

Mainly intended for use with the `clang++` compiler. The source files go to `src` and the header files go to `include`. To compile, simply run

```sh
make
```

which will compile the code with debug flags, which are available in the `Makefile`. To run the code you can use `make run`, and to compile the code with release flags you can use `make release`. The compiled object files will be placed in `target/debug` and `target/release` respectively. See the `Makefile` for all the make options available.

## Getting started

You simply need `git` and `make` installed, along with a C++ compiler. Copy the repository with the following command:

```sh
git clone https://github.com/Amir1453/cpp-base.git
```

and change CXX in `Makefile` so that it matches your C++ compiler.

If using `clangd`, utilize [bear](https://github.com/rizsotto/Bear) as follows:

```sh
make clean
bear -- make
```

This will create the file `compile_commands.json`, which will fix the erroneous `clangd` messages.
