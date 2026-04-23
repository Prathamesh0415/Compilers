%{
#include "ast.h"
#include "parser.tab.h"
#include <string.h>
%}

%%
"switch"    { return SWITCH; }
"case"      { return CASE; }
"default"   { return DEFAULT; }
"break"     { return BREAK; }

[a-zA-Z0-9_]+   { yylval.str = strdup(yytext); return TEXT; }
[-=+\/\*<>\!]+  { yylval.str = strdup(yytext); return TEXT; }
\"[^\"]*\"      { yylval.str = strdup(yytext); return TEXT; } /* Handle strings */

[{}();:]    { return yytext[0]; }
[ \t\n]     ; 
.           { return yytext[0]; }
%%

int yywrap() { return 1; }