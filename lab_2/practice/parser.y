%{
    #include <stdio.h>
    #include <stdlib.h>

    int yylex();
    void yyerror(const char*s);
%}

%token NUMBER

%%
expr : NUMBER '+' NUMBER
    {
        printf("Valid Expression\n");
    }
%%

int main(){
    printf("Enter Expression: ");
    yyparse();
    return 0;
}

void yyerror(const char*s){
    printf("Invalid expression\n");
}