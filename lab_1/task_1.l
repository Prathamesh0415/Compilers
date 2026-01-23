%{
#include <stdio.h>
int counter = 0;
%}

%%
[a-zA-Z] {counter++;}
.\n {}
%%

int main(void){
    yylex();
    printf("\nThe number of alphabets are : %d\n", counter);
    return 0;
}

int yywrap(){
    return 1;
}