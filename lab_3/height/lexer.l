%{
    #include "parser.tab.h"
    #include <stdlib.h>
%}

%%
[a-z0-9A-Z] {
    yylval = yytext[0];
    return ID;
}
\n {return 0;}
[ \t] ;
. {return yytext[0];}

%%

int yywrap(){
    return 1;
}