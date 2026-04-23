#ifndef AST_H
#define AST_H

typedef enum { 
    NODE_FOR, 
    NODE_DO_WHILE, 
    NODE_WHILE, 
    NODE_STMT, 
    NODE_CONTINUE, 
    NODE_BREAK 
} NodeType;

typedef struct ASTNode {
    NodeType type;
    char* raw_text;             
    
    struct ASTNode* init;       
    struct ASTNode* cond;       
    struct ASTNode* inc;       
    struct ASTNode* body;       
    
    struct ASTNode* next;      
} ASTNode;

ASTNode* make_stmt(char* text);
ASTNode* make_keyword(NodeType type);
ASTNode* make_for(ASTNode* init, ASTNode* cond, ASTNode* inc, ASTNode* body);
ASTNode* make_do_while(ASTNode* body, ASTNode* cond);
ASTNode* make_while(ASTNode* cond, ASTNode* body);

void print_as_while(ASTNode* node, ASTNode* current_for_inc);

#endif