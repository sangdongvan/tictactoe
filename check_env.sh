#!/bin/bash

if [ -z "$TICTACTOE_ENV_SET" ]; then
	echo "Error: TICTACTOE build environment is not set up. Use sh public.sh make ${command}"
	exit 1
fi
