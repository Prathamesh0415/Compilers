%{
    #include <stdio.h>
    #include <stdlib.h>

    int yylex();
    void yyerror(const char*s);
    int reductions = 0;
%}

%token ID

%left '+' '-'
%left '*' '/'
%right '^'

%%
final: expr {printf("number of reductions: %d\n", reductions);}

expr: expr '+' expr {printf("+"); reductions++;}
    |   expr '-' expr {printf("-"); reductions++;}
    |   expr '*' expr {printf("*"); reductions++;}
    |   expr '/' expr {printf("/"); reductions++;}
    |   expr '^' expr {printf("^"); reductions++;}
    |   ID {printf("%c", $1); reductions++;}

%%

int main(){
    printf("Enter expression: ");
    yyparse();
    return 0;
}

void yyerror(const char*s){
    printf("Error: %s\n", s);
}

