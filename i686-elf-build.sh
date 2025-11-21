#!/bin/bash

# Default args
jobs="${1:-4}"

GCC_VER=15.2.0
BINUTILS_VER=2.45.1
# GDB_VER=15.2

# Exports
#export PREFIX="/opt/i686-elf"
#export TARGET=i686-elf
export PREFIX="/opt/x86_64-elf"
export TARGET=x86_64-elf
export PATH="$PREFIX/bin:$PATH"

#sudo mkdir -p $PREFIX

mkdir -p $HOME/build-i686
cd $HOME/build-i686

# Downloads
wget https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VER/gcc-$GCC_VER.tar.gz
wget https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VER.tar.xz
# wget ftp://ftp.gnu.org/gnu/gdb/gdb-$GDB_VER/gdb-$GDB_VER.tar.xz

tar -xvf binutils-$BINUTILS_VER.tar.xz
tar -xvf gcc-$GCC_VER.tar.gz
# tar -xvf gdb-$GDB_VER.tar.xz

# Binutils
mkdir build-binutils
cd build-binutils
    ../binutils-$BINUTILS_VER/configure --target=$TARGET --prefix="$PREFIX" --disable-multilib --disable-nls --disable-werror
    make -j$jobs
    sudo make -j$jobs install
cd ..

# GCC
cd gcc-$GCC_VER
    ./contrib/download_prerequisites
cd ..

mkdir build-gcc
cd build-gcc
    ../gcc-$GCC_VER/configure --target=$TARGET --prefix="$PREFIX" --disable-multilib --disable-nls --disable-werror --enable-languages=c,c++ --without-headers --without-isl
    make -j$jobs all-gcc
    make -j$jobs all-target-libgcc
    sudo make -j$jobs install-gcc
    sudo make -j$jobs install-target-libgcc
cd ..

# GDB
# mkdir build-gdb
# cd build-gdb
#     ../gdb-$GDB_VER/configure --target="$TARGET" --prefix="$PREFIX"
#     make -j$jobs
#     sudo make -j$jobs install
# cd ..

cd $HOME
# rm -rf $HOME/build-i686

