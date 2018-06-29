#!/bin/sh

# Compile the latest web assembly and abi files

eosiocpp -o reliefchain/reliefchain.wast reliefchain/reliefchain.cpp
eosiocpp -g reliefchain/reliefchain.abi reliefchain/reliefchain.hpp