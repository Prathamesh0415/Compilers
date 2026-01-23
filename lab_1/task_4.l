%{
#include <stdio.h>
int found = 0;
%}

%%
[^a-zA-Z\n]   { found = 1; }
[a-zA-Z\n]    { }
%%

int main() {
    yylex();
    if(found)
        printf("Non-alphabet character found\n");
    else
        printf("Only alphabets present\n");
    return 0;
}

int yywrap() {
    return 1;
}
