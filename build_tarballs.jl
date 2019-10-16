# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "WABT"
version = v"1.0.12"

# Collection of sources required to build WABT
sources = [
    "https://github.com/WebAssembly/wabt.git" =>
    "cf261f2bd561297e0da7008ddde8c09ba5ea35a2",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd wabt
git submodule update --init
mkdir build 
cd build
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain ..
make -j8
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf),
    MacOS(:x86_64),
    FreeBSD(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    ExecutableProduct(prefix, "wasm-interp", :wasm_interp),
    ExecutableProduct(prefix, "wat2wasm", :wat2wasm),
    ExecutableProduct(prefix, "wasm2c", :wasm2c),
    ExecutableProduct(prefix, "wast2json", :wast2json),
    ExecutableProduct(prefix, "wat-desugar", :wat_desugar),
    ExecutableProduct(prefix, "wasm2wat", :wasm2wat),
    ExecutableProduct(prefix, "wasm-validate", :wasm_validate),
    ExecutableProduct(prefix, "wasm-opcodecnt", :wasm_opcodecnt),
    ExecutableProduct(prefix, "wasm-objdump", :wasm_objdump),
    ExecutableProduct(prefix, "wasm-strip", :wasm_strip),
    ExecutableProduct(prefix, "spectest-interp", :spectest_interp)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
