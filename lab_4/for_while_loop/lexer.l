%{
#include "ast.h"
#include "parser.tab.h"
#include <string.h>
%}

%%
"for"       { return FOR; }
"while"     { return WHILE; }
"do"        { return DO; }
"continue"  { return CONTINUE; }
"break"     { return BREAK; }

[a-zA-Z0-9_]+   { yylval.str = strdup(yytext); return TEXT; }
[=+-\/\*<>\!]+  { yylval.str = strdup(yytext); return TEXT; }

[{}();]     { return yytext[0]; }
[ \t\n]     ; /* Ignore whitespace */
.           { return yytext[0]; }
%%

int yywrap() { return 1; }