#include <stdio.h>

void copy()
{
    extern char line[];
    line[1] = line[0];
}