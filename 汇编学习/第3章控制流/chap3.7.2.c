#include <stdio.h>

main()
{
    int a = 0;
    for (int i = 0; i<100; i++) {
        if (a == 10) {continue;}
        a++;
    }
}