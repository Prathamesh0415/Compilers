%{
#include "ast.h"
#include "parser.tab.h"
#include <string.h>
%}

%%
"if"        { return IF; }
"else"      { return ELSE; }

[a-zA-Z0-9_]+   { yylval.str = strdup(yytext); return TEXT; }
[-=+\/\*<>\!]+  { yylval.str = strdup(yytext); return TEXT; }
\"[^\"]*\"      { yylval.str = strdup(yytext); return TEXT; } 

[{}();,]    { return yytext[0]; }
[ \t\n]     ; 
.           { return yytext[0]; }
%%

int yywrap() { return 1; }