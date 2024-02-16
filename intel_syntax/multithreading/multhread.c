#ifndef _GNU_SOURCE
  #define _GNU_SOURCE
#endif
#include <stdio.h>
#include <linux/sched.h>
#include <sched.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <stdint.h>
#include <signal.h>

char stack[4096];

int thread2(void *arg) {
  printf("Hi from thread 2!\n");
  
  return 0;
}

int main() {
  printf("Hi from thread 1!\n");

  clone(&thread2, (stack + sizeof(stack)), 0, NULL, NULL, NULL);

  return 0;
}