%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int yylex();
    void yyerror(const char *s);

    char buffer[100];
    int index_count = 0;

    void check_palindrome();
%}

%token CHAR

%%
start : STR { 
            check_palindrome(); 
            index_count = 0;
        }
      ;

STR : STR CHAR { 
          buffer[index_count++] = $2; 
      }
    | CHAR { 
          buffer[index_count++] = $1; 
      }
    ;

%%

int main(){
    printf("Enter string: ");
    yyparse();
    return 0;
}

void yyerror(const char* s){
    printf("\nError: %s\n", s);
}

void check_palindrome() {
    int i = 0;
    int j = index_count - 1;
    
    while (i < j) {
        if (buffer[i] != buffer[j]) {
            printf("Not a Palindrome (Mismatch at pos %d and %d)\n", i, j);
            return;
        }
        i++;
        j--;
    }
    printf("Valid Palindrome string.\n");
}