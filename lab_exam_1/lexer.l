%{
    #include <stdio.h>
%}

%%

[1-9][0-9]*|0               { printf("Integer      : %s\n", yytext); }

[0-9]*\.[0-9]+|[0-9]+\.[0-9]* { printf("Float        : %s\n", yytext); }

0[0-7]+                     { printf("Octal        : %s\n", yytext); }

0[xX][0-9a-fA-F]+           { printf("Hexadecimal  : %s\n", yytext); }

[ \t\n]+                   

.                           { printf("Unknown      : %s\n", yytext); }

%%

int yywrap() {
    return 1;
}

int main() {
    printf("Enter numbers (Press Ctrl+D to stop):\n");
    yylex();
    return 0;
}