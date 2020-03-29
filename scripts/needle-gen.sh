#!/bin/bash

if which needle > /dev/null; then
    export SOURCEKIT_LOGGING=0 && needle generate Sources/Needle.gen.swift \
        Sources/ \
        ../../Libraries/TicTacToeRib/Sources
else
    echo "warning: Needle not installed, download it from https://github.com/uber/needle"
fi
