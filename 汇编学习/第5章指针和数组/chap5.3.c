#include <stdio.h>

void f1() {
    int a[2];
    int b = a[1];
}

void f2() {
    int a[2];
    int b = *(a+1);
}