%{
#include "parser.tab.h"
#include <string.h>
%}

%%
[0-9]   { 
            yylval.str = strdup(yytext); 
            return INT; 
        }

"+"     { return PLUS; }
"*"     { return MUL; }
[ \t]   { /* Ignore whitespace */ }
\n      { return '\n'; }
.       { return yytext[0]; }

%%

int yywrap() {
    return 1;
}