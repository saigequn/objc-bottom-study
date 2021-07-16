#include <stdio.h>

struct point{
    float x;
    float y;
};

//结构体作为返回值
struct point makePoint(float x, float y){
    struct point p;
    p.x = x;
    p.y = y;
    return p;
}

//结构体作为参数
void logPoint(struct point p){
    printf("(%.2f, %.2f)", p.x, p.y);
}

int main(){
    struct point p = makePoint(1.5, 2.3);
    logPoint(p);
    return 0;
}