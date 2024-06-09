#!/bin/sh
set -eu

../sim.sh riscv_alu_tb ./*.vhd ../*.vhd
