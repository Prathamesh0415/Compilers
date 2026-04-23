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

%token SWITCH CASE DEFAULT BREAK
%token <str> TEXT

%type <node> statement statement_list case_list case_item expr

%%

program: statement_list { 
        root = $1; 
        printf("\n--- CONVERTED CODE ---\n\n");
        print_as_if(root, NULL, NULL); 
    } 
    ;

statement_list:
    /* empty */ { $$ = NULL; }
    | statement statement_list { if($1){ $1->next = $2; $$ = $1; } else { $$ = $2; } }
    ;

statement:
    SWITCH '(' expr ')' '{' case_list '}' {
        $$ = make_switch($3, $6);
    }
    | BREAK ';' { $$ = make_keyword(NODE_BREAK); }
    | expr ';' { 
        char buf[512];
        sprintf(buf, "%s;", $1->raw_text);
        $$ = make_stmt(strdup(buf)); 
    }
    ;

/* A switch body is just a list of cases */
case_list:
    case_item { $$ = $1; }
    | case_item case_list { $1->next = $2; $$ = $1; }
    ;

case_item:
    CASE expr ':' statement_list { $$ = make_case($2, $4); }
    | DEFAULT ':' statement_list { $$ = make_default($3); }
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