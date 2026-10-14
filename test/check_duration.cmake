function(run_duration duration output_var)
  if("${duration}" STREQUAL "default")
    set(arguments "--confidence=100")
  else()
    set(arguments "--duration=${duration}" "--confidence=100")
  endif()
  execute_process(
    COMMAND "${UBENCH_DURATION_TEST}" ${arguments}
    RESULT_VARIABLE result
    OUTPUT_VARIABLE output
    ERROR_VARIABLE error
  )
  if(NOT "${result}" STREQUAL "0")
    message(FATAL_ERROR
      "duration ${duration} failed (${result}): ${error}\n${output}")
  endif()
  string(REGEX MATCH "duration iterations: ([0-9]+)" match "${output}")
  if(NOT match)
    message(FATAL_ERROR "duration ${duration} did not report its sample count")
  endif()
  set(${output_var} "${CMAKE_MATCH_1}" PARENT_SCOPE)
endfunction()

run_duration(1 short_count)
run_duration(30 longer_count)
run_duration(default short_default_count)

if(NOT short_count LESS longer_count)
  message(FATAL_ERROR
    "30ms duration did not increase sampled work: 1ms=${short_count}, 30ms=${longer_count}")
endif()
if(NOT longer_count LESS short_default_count)
  message(FATAL_ERROR
    "default 100ms duration was not preserved: 30ms=${longer_count}, default=${short_default_count}")
endif()

foreach(invalid_duration IN ITEMS
    "" 0 -1 abc 1x 999999999999999999999999999999999999)
  execute_process(
    COMMAND "${UBENCH_DURATION_TEST}" "--duration=${invalid_duration}"
    RESULT_VARIABLE result
    OUTPUT_VARIABLE output
    ERROR_VARIABLE error
  )
  if("${result}" STREQUAL "0")
    message(FATAL_ERROR
      "invalid duration '${invalid_duration}' was accepted\n${output}")
  endif()
  if(NOT "${error}" MATCHES "Invalid duration")
    message(FATAL_ERROR
      "invalid duration '${invalid_duration}' had an unexpected error: ${error}")
  endif()
endforeach()

execute_process(
  COMMAND "${UBENCH_DURATION_TEST}" --duration=9223372036854 --list-benchmarks
  RESULT_VARIABLE result
  OUTPUT_VARIABLE output
  ERROR_VARIABLE error
)
if(NOT "${result}" STREQUAL "0")
  message(FATAL_ERROR
    "largest representable duration was rejected: ${error}\n${output}")
endif()

execute_process(
  COMMAND "${UBENCH_DURATION_TEST}" --duration=9223372036855 --list-benchmarks
  RESULT_VARIABLE result
  OUTPUT_VARIABLE output
  ERROR_VARIABLE error
)
if("${result}" STREQUAL "0" OR NOT "${error}" MATCHES "Invalid duration")
  message(FATAL_ERROR
    "duration nanosecond-conversion overflow was not rejected: ${error}\n${output}")
endif()
