%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *s);
%}

%token NUMBER

%%
expr : NUMBER '+' NUMBER
     {
        printf("Valid expression\n");
	printf("Result = %d\n", $1 + $3);
     }
     ;
%%
int main()
{
    printf("Enter expression: ");
    yyparse();
    return 0;
}

void yyerror(const char *s)
{
    printf("Invalid expression\n");
}
