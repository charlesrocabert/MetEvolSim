#!/bin/bash

bash make_clean.sh
cmake -DCMAKE_BUILD_TYPE=Debug ..
make
