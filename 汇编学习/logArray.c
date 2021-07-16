#include <stdio.h>

void logArray(int intArray[], size_t length){
    for(int i = 0; i < length;i++){
        printf("%d", intArray[i]);
    }
}

int main() {
    int arr[3] = {1, 2, 3};
    logArray(arr, 3);
    return 0;
}