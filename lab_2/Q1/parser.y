%{
    #include<stdio.h>
    #include<stdlib.h>
    int yylex();
    void yyerror(const char *s);
    int flag = 0;
%}

%token A B INVALID NL

%%
program: program start
        | start
        ;
start: expr NL {printf("This is a valid expression of the form a^nb^n. \n");} 
expr : A expr B
     |
%%

void yyerror(const char* s){
    printf("Invalid string\n");
}

int main(){
    printf("Enter string: ");
    yyparse();
    return 0;
}

