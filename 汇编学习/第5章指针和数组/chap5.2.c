#include <stdio.h>

void swap(int *px, int *py) {
    int temp;
    temp = *px;
    *px = *py;
    *py = temp;
}

int main()
{
    int a = 1;
    int b = 2;
    swap(&a, &b);    
    return 0;
}