#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Define the minimum required CMake version                                    #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
cmake_minimum_required(VERSION 2.6)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Define the project name                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
project(Holzhutter2004)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Define the package name                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
set(PACKAGE "\"Holzhutter2004\"")


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Define the version number                                                    #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
set(VERSION_MAJOR 0)
set(VERSION_MINOR 1)
set(VERSION_PATCH 0)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Add definitions to CXX flags                                                 #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
ADD_DEFINITIONS(-std=c++11)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Set DEBUG and RELEASE flags                                                  #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DDEBUG -g -pg -Wall -Wextra -pedantic")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -DNDEBUG -O3 -Wall -Wextra -pedantic")


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Define the modules path                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules" ${CMAKE_MODULE_PATH})


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Define the executables output path                                           #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
set(EXECUTABLE_OUTPUT_PATH ../build/bin)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Define the executables                                                       #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
set(RUN_EXECUTABLE run)
add_executable(${RUN_EXECUTABLE} src/run.cpp)

set(TESTS_EXECUTABLE tests)
add_executable(${TESTS_EXECUTABLE} src/tests.cpp)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Find and link external libraries                                             #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
find_package(ZLIB REQUIRED)
if(ZLIB_FOUND)
  include_directories(${ZLIB_INCLUDE_DIR})
  target_link_libraries(${RUN_EXECUTABLE} ${ZLIB_LIBRARIES})
  target_link_libraries(${TESTS_EXECUTABLE} ${ZLIB_LIBRARIES})
endif(ZLIB_FOUND)

find_package(GSL REQUIRED)
if(GSL_FOUND)
  include_directories(${GSL_INCLUDE_DIR})
  target_link_libraries(${RUN_EXECUTABLE} ${GSL_LIBRARIES})
  target_link_libraries(${TESTS_EXECUTABLE} ${GSL_LIBRARIES})
endif(GSL_FOUND)

find_package(TBB REQUIRED)
if(TBB_FOUND)
  include_directories(${TBB_INCLUDE_DIR})
  target_link_libraries(${RUN_EXECUTABLE} ${TBB_LIBRARIES})
  target_link_libraries(${TESTS_EXECUTABLE} ${TBB_LIBRARIES})
endif(TBB_FOUND)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Create and link Holzhutter2004 library                                       #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
add_library(
  Holzhutter2004
  src/lib/Macros.h
  src/lib/Enums.h
  src/lib/Structs.h
  src/lib/Prng.h
  src/lib/Prng.cpp
  src/lib/Parameters.h
  src/lib/Parameters.cpp
  src/lib/Individual.h
  src/lib/Individual.cpp
  src/lib/Node.h
  src/lib/Node.cpp
  src/lib/Tree.h
  src/lib/Tree.cpp
  src/lib/Population.h
  src/lib/Population.cpp
)

target_link_libraries(Holzhutter2004 z tbb gsl gslcblas )
target_link_libraries(${RUN_EXECUTABLE} Holzhutter2004)
target_link_libraries(${TESTS_EXECUTABLE} Holzhutter2004)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Build the Config.h file                                                      #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
configure_file(
  "${PROJECT_SOURCE_DIR}/cmake/modules/Config.h.in"
  "${PROJECT_BINARY_DIR}/Config.h"
)
include_directories("${PROJECT_BINARY_DIR}")

