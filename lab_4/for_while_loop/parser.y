%{
#include "ast.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *s);

ASTNode* root; // The top of our tree
%}

%union {
    char* str;
    struct ASTNode* node;
}

%token FOR WHILE DO CONTINUE BREAK
%token <str> TEXT

%type <node> statement statement_list block opt_expr expr

%%

program: statement_list { 
        root = $1; 
        printf("\n--- CONVERTED CODE ---\n\n");
        print_as_while(root, NULL); 
    } 
    ;

statement_list:
    statement { $$ = $1; }
    | statement statement_list { $1->next = $2; $$ = $1; }
    ;

block:
    '{' statement_list '}' { $$ = $2; }
    | statement { $$ = $1; }
    ;

statement:
    FOR '(' opt_expr ';' opt_expr ';' opt_expr ')' block {
        $$ = make_for($3, $5, $7, $9);
    }
    | DO block WHILE '(' expr ')' ';' {
        $$ = make_do_while($2, $5);
    }
    | WHILE '(' expr ')' block {
        $$ = make_while($3, $5);
    }
    | CONTINUE ';' { $$ = make_keyword(NODE_CONTINUE); }
    | BREAK ';' { $$ = make_keyword(NODE_BREAK); }
    | expr ';' { 
        // Add the semicolon back for standard statements
        char buf[256];
        sprintf(buf, "%s;", $1->raw_text);
        $$ = make_stmt(strdup(buf)); 
    }
    ;

opt_expr:
    /* empty */ { $$ = NULL; }
    | expr { $$ = $1; }
    ;

/* The Snowball Rule: Glues tokens together into one expression string */
expr:
    TEXT { $$ = make_stmt($1); }
    | expr TEXT { 
        char buf[256]; 
        sprintf(buf, "%s %s", $1->raw_text, $2); 
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