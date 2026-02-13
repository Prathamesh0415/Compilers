%{
    #include "parser.tab.h"
%}

%%
"("  {return OPEN;}
")"  {return CLOSE;}
\n {return 0;}

%%

int yywrap(){
    return 1;
}