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

%token WHILE DO FOR BREAK CONTINUE
%token <str> TEXT

%type <node> statement statement_list block opt_expr expr

%%

program: statement_list { 
        root = $1; 
        printf("\n--- CONVERTED CODE ---\n\n");
        print_as_for(root); 
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
    WHILE '(' expr ')' block {
        $$ = make_while($3, $5);
    }
    | DO block WHILE '(' expr ')' ';' {
        $$ = make_do_while($2, $5);
    }
    | FOR '(' opt_expr ';' opt_expr ';' opt_expr ')' block {
        $$ = make_for($3, $5, $7, $9);
    }
    | BREAK ';' { $$ = make_stmt("break;"); }
    | CONTINUE ';' { $$ = make_stmt("continue;"); }
    | expr ';' { 
        char buf[512];
        sprintf(buf, "%s;", $1->raw_text);
        $$ = make_stmt(strdup(buf)); 
    }
    ;

opt_expr:
    /* empty */ { $$ = NULL; }
    | expr { $$ = $1; }
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
    | expr '(' ')' {
        char buf[512];
        sprintf(buf, "%s()", $1->raw_text);
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