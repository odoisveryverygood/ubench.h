/*
   This is free and unencumbered software released into the public domain.

   Anyone is free to copy, modify, publish, use, compile, sell, or
   distribute this software, either in source code form or as a compiled
   binary, for any purpose, commercial or non-commercial, and by any
   means.
*/

#include "ubench.h"

UBENCH_STATE();

extern unsigned long iteration_count;
unsigned long iteration_count = 0;

int main(int argc, const char *const argv[]) {
  const int result = ubench_main(argc, argv);
  printf("duration iterations: %lu\n", iteration_count);
  return result;
}
