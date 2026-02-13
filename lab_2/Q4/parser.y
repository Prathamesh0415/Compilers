%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Node {
    char *value;
    struct Node *left;
    struct Node *right;
} Node;

Node* createNode(char *value, Node *left, Node *right);
void preorder(Node *root);
void inorder(Node *root);
void postorder(Node *root);
int yylex();
void yyerror(const char *s);
%}

%union {
    char *str;
    struct Node *node;
}

%token <str> INT
%token PLUS MUL

%type <node> E

%left PLUS      
%left MUL       

%%
program:
    E '\n' {
        printf("\n--- Evaluation Tree Traversals ---\n");
        printf("Pre-order:  "); preorder($1); printf("\n");
        printf("In-order:   "); inorder($1); printf("\n");
        printf("Post-order: "); postorder($1); printf("\n");
        exit(0);
    }
    | E {
        printf("\n--- Evaluation Tree Traversals ---\n");
        printf("Pre-order:  "); preorder($1); printf("\n");
        printf("In-order:   "); inorder($1); printf("\n");
        printf("Post-order: "); postorder($1); printf("\n");
        exit(0);
    }
    ;

E:
      E PLUS E    { $$ = createNode("+", $1, $3); }
    | E MUL E     { $$ = createNode("*", $1, $3); }
    | INT         { $$ = createNode($1, NULL, NULL); }
    ;

%%

Node* createNode(char *value, Node *left, Node *right) {
    Node *newNode = (Node*)malloc(sizeof(Node));
    newNode->value = strdup(value);
    newNode->left = left;
    newNode->right = right;
    return newNode;
}

void preorder(Node *root) {
    if (root == NULL) return;
    printf("%s ", root->value);
    preorder(root->left);
    preorder(root->right);
}

void inorder(Node *root) {
    if (root == NULL) return;
    inorder(root->left);
    printf("%s ", root->value);
    inorder(root->right);
}

void postorder(Node *root) {
    if (root == NULL) return;
    postorder(root->left);
    postorder(root->right);
    printf("%s ", root->value);
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter input string (e.g., 3+4*5): ");
    yyparse();
    return 0;
}