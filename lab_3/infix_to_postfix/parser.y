%{
    #include <stdio.h>
    #include <stdlib.h>

    int yylex();
    void yyerror(const char*s);
%}

%token ID

%left '+' '-'
%left '*' '/'
%right '^'

%%
final: expr {printf("\n");}

expr: expr '+' expr {printf("+");}
    |   expr '-' expr {printf("-");}
    |   expr '*' expr {printf("*");}
    |   expr '/' expr {printf("/");}
    |   expr '^' expr {printf("^");}
    |   ID {printf("%c", $1);}

%%

int main(){
    printf("Enter expression: ");
    yyparse();
    return 0;
}

void yyerror(const char*s){
    printf("Error: %s\n", s);
}

