#include <stdio.h>

int max(int a, int b){
    if(a >=b){
        return a;
    } else {
        return b;
    }
}

int main()
{
    int a = 10;
    int b = 20;
    int c = max(a, b);
    return 0;
}