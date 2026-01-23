%{
#include <stdio.h>
int found = 0;
%}

%%
[^a-zA-Z \t\n]   { found = 1; }
[a-zA-Z\t\n]    { }
%%

int main() {
    yylex();
    if(found)
        printf("\nNon-alphabet character found\n");
    else
        printf("\nOnly alphabets present\n");
    return 0;
}

int yywrap() {
    return 1;
}
