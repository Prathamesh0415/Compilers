%{
#include "parser.tab.h"
#include <stdlib.h>
%}

%%
[0-9]+      { yylval = atoi(yytext); return NUMBER; }
[+]         { return '+'; }
\n          { return 0; }
[ \t]       ;        /* ignore spaces */
.           ;        /* ignore other characters */
%%
int yywrap()
{
    return 1;
}
