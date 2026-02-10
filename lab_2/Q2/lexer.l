%{
    #include "parser.tab.h"
%}

%%
[a-zA-Z] { yylval = yytext[0]; return CHAR; } /* Catch letters */
\n       { return 0; }                        /* End of input */
.        { return 0; }                        /* Ignore other chars */
%%

int yywrap() {
    return 1;
}