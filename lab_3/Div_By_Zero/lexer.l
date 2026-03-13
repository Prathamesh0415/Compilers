%{
    #include "parser.tab.h"
    #include <stdlib.h>
%}

%%
[0-9]+ {yylval = atoi(yytext); return NUMBER;}
[/] {return '/';}
\n {return 0;}
[ \t] ;
. ;
%%

int yywrap(){
    return 1;
}