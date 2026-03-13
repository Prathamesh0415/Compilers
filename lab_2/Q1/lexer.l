%{
    #include "parser.tab.h"
    #include <stdlib.h>
%}

%%
a { return A;}
b {return B;}
\n {return NL;}
. {return INVALID;}
%%

int yywrap(){
    return 1;
}