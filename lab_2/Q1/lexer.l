%{
    #include "parser.tab.h"
    #include <stdlib.h>
%}

%%
a { return A;}
b {return B;}
ba {return INVALID;}
\n {return 0;}
. {return INVALID;}
%%

int yywrap(){
    return 1;
}