%{
    #include<stdio.h>    
    int char_count = 0;
    int word_count = 0;
    int line_count = 0;
%}

%%
\n {char_count++; line_count++;}
[ \t]+ {char_count++;}
[a-zA-Z]+ {word_count++; char_count += yyleng;}
. {char_count++;}
%%

int main(void){
    yylex();
    printf("\n%d %d %d", char_count, word_count, line_count);
    return 0;
}

int yywrap(){
    return 1;
}