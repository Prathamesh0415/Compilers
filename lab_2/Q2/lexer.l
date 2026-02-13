%{
    #include "parser.tab.h"
%}

%%
[a-zA-Z] { yylval = yytext[0]; return CHAR; } 
\n       { return 0; }                        
.        { return 0; }                        
%%

int yywrap() {
    return 1;
}