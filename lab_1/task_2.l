%{
#include <stdio.h>
int pos_counter = 0;
int neg_counter = 0;
%}

%%
[+][0-9]* {pos_counter++;}
[0-9]* {pos_counter++;}
[-][0-9]* {neg_counter++;}
%%

int main(void){
    yylex();
    printf("\n");
    printf("%d %d \n", pos_counter, neg_counter);
    return 0;
}

int yywrap(){
    return 1;
}