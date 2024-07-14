#!/bin/sh
set -eu

../sim.sh uart_rx_tb ./*.vhd ../*.vhd ../ex07/*.vhd
