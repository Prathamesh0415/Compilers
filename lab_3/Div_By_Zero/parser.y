%{
    #include <stdio.h>
    #include <stdlib.h>

    int yylex();
    void yyerror(const char*s);
%}

%token NUMBER

%%
expr: NUMBER '/' NUMBER {
    if($3 == 0){
        yyerror("Division by zero error");
    }
    printf("Result: %d\n", $1 / $3);
} 

%%

int main()
{
    printf("Enter expression: ");
    yyparse();
    return 0;
}

void yyerror(const char *s)
{
    printf("Error: %s\n", s);
}
