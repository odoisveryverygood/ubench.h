/*
   This is free and unencumbered software released into the public domain.

   Anyone is free to copy, modify, publish, use, compile, sell, or
   distribute this software, either in source code form or as a compiled
   binary, for any purpose, commercial or non-commercial, and by any
   means.
*/

#include "ubench.h"

extern unsigned long iteration_count;

UBENCH_EX(duration, one_millisecond) {
  UBENCH_DO_BENCHMARK() {
    const ubench_int64_t start_ns = ubench_ns();
    while ((ubench_ns() - start_ns) < 1000000) {
    }
    iteration_count++;
  }
}
