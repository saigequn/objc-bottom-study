#include <stdio.h>

void hello_word(int * a){
    *a = 10;
}

int main() {
    int * a;
    hello_word(a);
    printf("%d", *a);
    return 0;
}