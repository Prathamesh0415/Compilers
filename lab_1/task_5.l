%{
#include <stdio.h>
%}

%%
[a-zA-Z]{3,5} { printf("Valid string: %s\n", yytext); }
[a-zA-Z]+     {  }
.|\n          {  }
%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}