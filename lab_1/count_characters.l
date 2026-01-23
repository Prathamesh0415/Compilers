%{
#include <stdio.h>
int counter = 0;
%}

%%
[a-zA-Z] {counter++;}
.|\n     {}
%%

int main(void){
    yylex();
    printf("The number of constants + vowels are %d", counter);
    return 0;
}

int yywrap(){
    return 1;
}