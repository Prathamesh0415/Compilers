%{
    #include <stdio.h>
    #include <stdlib.h>

    int yylex();
    void yyerror(const char *s);

%}

%token ONE ZERO

%%
    expr: sequence {
        printf("The number of ones in the sequence are: %d\n", $1);
    }
    sequence: bit { $$ = $1;} 
            | sequence bit { $$ = $1 + $2;}

    bit: ONE { $$ = 1;}
        | ZERO { $$ = 0;}    
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