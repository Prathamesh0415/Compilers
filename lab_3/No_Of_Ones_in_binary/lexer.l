%{
    #include "parser.tab.h"
    #include <stdlib.h>
%}

%%
1 {return ONE;}
0 {return ZERO;}
\n {return 0;}
[ \t]       ;        /* ignore spaces */
.           ;        /* ignore other characters */
%%

int yywrap(){
    return 1;
}