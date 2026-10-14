# Run a test program and compare its standard output with a reference file
# using compare_output (white space ignored, numbers compared with a
# tolerance).
#
#   cmake -DEXECUTABLE=<program> -DCOMPARE=<compare_output>
#         -DREFERENCE=<file> -DOUTPUT=<file> [-DRTOL=<r>] [-DATOL=<a>]
#         -P RunAndCompare.cmake

foreach(_var IN ITEMS EXECUTABLE COMPARE REFERENCE OUTPUT)
  if(NOT DEFINED ${_var})
    message(FATAL_ERROR "RunAndCompare.cmake: ${_var} is not set")
  endif()
endforeach()

execute_process(
  COMMAND "${EXECUTABLE}"
  OUTPUT_FILE "${OUTPUT}"
  RESULT_VARIABLE _result)
if(NOT _result EQUAL 0)
  message(FATAL_ERROR "${EXECUTABLE} failed: ${_result}")
endif()

set(_tolerances "")
if(DEFINED RTOL)
  list(APPEND _tolerances "${RTOL}")
  if(DEFINED ATOL)
    list(APPEND _tolerances "${ATOL}")
  endif()
endif()

execute_process(
  COMMAND "${COMPARE}" "${OUTPUT}" "${REFERENCE}" ${_tolerances}
  RESULT_VARIABLE _result)
if(NOT _result EQUAL 0)
  message(FATAL_ERROR "Output ${OUTPUT} differs from reference ${REFERENCE}")
endif()
