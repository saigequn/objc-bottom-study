#include <stdio.h>

main()
{
    int a = 0;
    for (;;) {
        a++;
        if (a == 10) {goto end;} 
    }
    a += 2;
end:
    a += 3;
}