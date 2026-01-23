%{
#include <stdio.h>
int pos_counter = 0;
int neg_counter = 0;
int pos_fracs = 0;
int neg_fracs = 0;
%}

%%
^[0-9]+ {pos_counter++;}
[ \t\n][0-9]+ {pos_counter++;}
^[+][0-9]+ {pos_counter++;}
[ \t\n]+[+][0-9]+ {pos_counter++;}
^[-][0-9]+ {neg_counter++;}
[ \t\n]+[-][0-9]+ {neg_counter++;}
^[0-9]+[/][0-9]+ {pos_fracs++;}
[ \t\n]+[0-9]+[/][0-9]+ {pos_fracs++;}
^[+][0-9]+[/][0-9]+ {pos_fracs++;}
[ \t\n]+[+][0-9]+[/][0-9]+ {pos_fracs++;}
^[-][0-9]+[/][0-9]+ {neg_fracs++;}
[ \t\n]+[-][0-9]+[/][0-9]+ {neg_fracs++;}
%%

int main(void){
    yylex();
    printf("\n");
    printf("positive: %d negative: %d positive fractions: %d negative fractions: %d\n", pos_counter, neg_counter, pos_fracs, neg_fracs);
    return 0;
}

int yywrap(){
    return 1;
}