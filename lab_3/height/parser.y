%{
    #include <stdio.h>
    #include <stdlib.h>

    int yylex();
    void yyerror(const char*s);

    int max(int a, int b){
        return a > b ? a : b;
    }
%}

%token ID

%left '+' '-'
%left '*' '/'
%right '^'

%%
final: expr {
    printf("The height of the tree is: %d\n", $1);
}

    | expr '-' expr {$$ = 1 + max($1, $3);}
expr: expr '+' expr {$$ = 1 + max($1, $3);}
    | expr '*' expr {$$ = 1 + max($1, $3);}
    | expr '/' expr {$$ = 1 + max($1, $3);}
    | expr '^' expr {$$ = 1 + max($1, $3);}
    | ID {$$ = 1;}

%%

int main(){
    printf("Enter expression: \n");
    yyparse();
    return 0;
}

void yyerror(const char *s){
    printf("Error: %s\n", s);
}