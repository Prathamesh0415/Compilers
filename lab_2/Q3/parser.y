%{
    #include <stdio.h>
    void yyerror(const char* s);
    int yylex();
%}

%token OPEN CLOSE

%%
start: expr {printf("valid parenthsis\n");}
expr: OPEN expr CLOSE expr
    | 
    ;

%%

int main(){
    printf("Enter String: \n");
    yyparse();
    return 0;
}

void yyerror(const char* s){
    printf("Invalid String\n");
}