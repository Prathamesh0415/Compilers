%{
#include <stdio.h>
%}

%%
[0-9]   { printf("Digit found\n"); }
%%

int main(void)
{
    yylex();
    return 0;
}

int yywrap(void)
{
    return 1;
}
