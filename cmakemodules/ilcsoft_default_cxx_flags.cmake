## Set the default compiler flags for all projects picking up default ilcutil settings
## This runs checks if compilers support the flag and sets them, if they do
## this will create a humongous amount of warnings when compiling :)

INCLUDE(CheckCXXCompilerFlag)

SET(COMPILER_FLAGS -Wall -Wextra -Wshadow -Weffc++ -pedantic -Wno-long-long -Wuninitialized )

IF( "${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU" )
 LIST( APPEND COMPILER_FLAGS -Wl,-no-undefined )
ENDIF()


MESSAGE( STATUS "FLAGS ${COMPILER_FLAGS}" )
FOREACH( FLAG ${COMPILER_FLAGS} )

  ## meed to replace the minus or plus signs from the variables, because it is passed
  ## as a macro to g++ which causes a warning about no whitespace after macro
  ## definition
  STRING(REPLACE "-" "_" FLAG_WORD ${FLAG} )
  STRING(REPLACE "+" "P" FLAG_WORD ${FLAG_WORD} )

  CHECK_CXX_COMPILER_FLAG( "${FLAG}" CXX_FLAG_WORKS_${FLAG_WORD} )
  IF( ${CXX_FLAG_WORKS_${FLAG_WORD}} )
    MESSAGE ( STATUS "Adding ${FLAG} to CXX_FLAGS" )
    ### We prepend the flag, so they are overwritten by whatever the user sets in his own configuration
    SET ( CMAKE_CXX_FLAGS "${FLAG} ${CMAKE_CXX_FLAGS}")
  ELSE()
    MESSAGE ( STATUS "NOT Adding ${FLAG} to CXX_FLAGS" )
  ENDIF()
ENDFOREACH()

OPTION( ILCSOFT_CXX_STANDARD "Use CXX Standard" 11 )

IF( cxx_std_${ILCSOFT_CXX_STANDARD} IN_LIST CMAKE_CXX_COMPILE_FEATURES )
  SET( CMAKE_CXX_STANDARD ${ILCSOFT_CXX_STANDARD} )
  SET( CMAKE_CXX_STANDARD_REQUIRED ON )
  SET( CMAKE_CXX_EXTENSIONS OFF )
ELSE()
  MESSAGE( FATAL_ERROR "Compiler does not support C++${ILCSOFT_CXX_STANDARD} standard" )
ENDIF()

IF( "${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.9 )
  SET( CMAKE_CXX_FLAGS "-fdiagnostics-color=auto ${CMAKE_CXX_FLAGS}" )
ENDIF()
