#include <fcgi_stdio.h>
#include <stdlib.h>

int main(void)
{
    while(FCGI_Accept() >= 0) {
        printf("Content-Type: text/html\r\n\r\n");
        printf("<h1>Hello, World!</h1>");
    }
    
    return 0;
}