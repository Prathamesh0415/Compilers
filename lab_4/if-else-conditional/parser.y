%{
#include "ast.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *s);
ASTNode* root;
%}

%union {
    char* str;
    struct ASTNode* node;
}

%token IF ELSE
%token <str> TEXT

/* Solve the dangling-else Shift/Reduce conflict */
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%type <node> statement statement_list block expr

%%

program: statement_list { 
        root = $1; 
        printf("\n--- CONVERTED TERNARY CODE ---\n\n");
        convert_to_ternary(root); 
    } 
    ;

statement_list:
    /* empty */ { $$ = NULL; }
    | statement statement_list { if($1){ $1->next = $2; $$ = $1; } else { $$ = $2; } }
    ;

block:
    '{' statement_list '}' { $$ = make_block($2); }
    | statement { $$ = $1; }
    ;

statement:
    IF '(' expr ')' block %prec LOWER_THAN_ELSE {
        $$ = make_if($3, $5, NULL);
    }
    | IF '(' expr ')' block ELSE block {
        $$ = make_if($3, $5, $7);
    }
    | expr ';' { 
        // Notice we do NOT append a semicolon here anymore!
        $$ = make_stmt($1->raw_text); 
    }
    ;

/* Snowball expression rule */
expr:
    TEXT { $$ = make_stmt($1); }
    | expr TEXT { 
        char buf[512]; 
        sprintf(buf, "%s %s", $1->raw_text, $2); 
        $$ = make_stmt(strdup(buf)); 
    }
    | expr '(' expr ')' {
        char buf[512];
        sprintf(buf, "%s(%s)", $1->raw_text, $3->raw_text);
        $$ = make_stmt(strdup(buf));
    }
    ;

%%

int main() {
    printf("Enter C code (Press Ctrl+D to evaluate):\n");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    printf("Syntax Error\n");
}