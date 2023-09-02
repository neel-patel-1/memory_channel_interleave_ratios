#!/bin/bash

wget http://ftp.gnu.org/gnu/gzip/gzip-1.10.tar.gz
tar -xf gzip-1.10.tar.gz
echo y | sudo apt install -y build-essential

cd gzip-1.10
./configure
make -j