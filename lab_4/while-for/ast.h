#ifndef AST_H
#define AST_H

typedef enum { 
    NODE_WHILE, 
    NODE_DO_WHILE, 
    NODE_FOR, 
    NODE_STMT, 
    NODE_BLOCK 
} NodeType;

typedef struct ASTNode {
    NodeType type;
    char* raw_text;             
    
    struct ASTNode* init;       // For preserving existing for-loops
    struct ASTNode* cond;       
    struct ASTNode* inc;        
    struct ASTNode* body;       
    
    struct ASTNode* next;       
} ASTNode;

ASTNode* make_stmt(char* text);
ASTNode* make_block(ASTNode* body);
ASTNode* make_while(ASTNode* cond, ASTNode* body);
ASTNode* make_do_while(ASTNode* body, ASTNode* cond);
ASTNode* make_for(ASTNode* init, ASTNode* cond, ASTNode* inc, ASTNode* body);

void print_as_for(ASTNode* node);

#endif