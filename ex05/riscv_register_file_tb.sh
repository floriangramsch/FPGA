#!/bin/sh
set -eu

../sim.sh riscv_register_file_tb ./*.vhd ../*.vhd
