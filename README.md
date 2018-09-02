# MetEvolSim

An individual-based simulator of metabolome evolution

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

## Authors

Charles Rocabert, Gábor Boross, Bálazs Papp.

## Installation instructions

Download the latest release, and save it to a directory of your choice. Open a terminal and use the <code>cd</code> command to navigate to this directory. Then follow the steps below to compile and build the executables.

### 1. Supported platforms

This software has been developed for Unix and OSX (macOS) systems.

### 2. Required dependencies

* A C++ compiler (GCC, LLVM, ...)
* CMake (command line version)
* zlib
* GSL
* CBLAS
* TBB

### 3. Software compilation

#### User mode

For each model (ToyModels, or Holzhutter2004), first navigate to the model folder (<code>cd Toymodels</code>, or <code>cd Holzhutter2004</code>).

To compile the software, run the following instructions on the command line:

    cd cmake/

and

    bash make.sh

#### Debug mode

To compile the software in DEBUG mode, use <code>make_debug.sh</code> script instead of <code>make.sh</code>:

    bash make_debug.sh

This mode should only be used for tests or development phases.

#### Executable files emplacement

Binary executable files are in <code>build/bin</code> folder.

