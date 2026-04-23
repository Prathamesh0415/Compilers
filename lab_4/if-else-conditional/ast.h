#ifndef AST_H
#define AST_H

typedef enum { 
    NODE_IF, 
    NODE_STMT, 
    NODE_BLOCK 
} NodeType;

typedef struct ASTNode {
    NodeType type;
    char* raw_text;             
    
    struct ASTNode* cond;       // The 'if' condition
    struct ASTNode* body;       // The 'true' branch
    struct ASTNode* else_body;  // The 'false' branch (or the next 'else if')
    
    struct ASTNode* next;       // For linked lists of statements
} ASTNode;

ASTNode* make_stmt(char* text);
ASTNode* make_block(ASTNode* body);
ASTNode* make_if(ASTNode* cond, ASTNode* body, ASTNode* else_body);

// The two-step translation functions
void print_ternary_expr(ASTNode* node);
void convert_to_ternary(ASTNode* node);

#endif