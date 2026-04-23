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
    char* raw_text;             // Holds text like "i = 0" or "x < 10"
    
    struct ASTNode* init;       // For loop init
    struct ASTNode* cond;       // Loop condition
    struct ASTNode* inc;        // For loop increment
    struct ASTNode* body;       // The code inside the loop
    
    struct ASTNode* next;       // Pointer to the next statement in the block
} ASTNode;

// Function Prototypes
ASTNode* make_stmt(char* text);
ASTNode* make_keyword(NodeType type);
ASTNode* make_for(ASTNode* init, ASTNode* cond, ASTNode* inc, ASTNode* body);
ASTNode* make_do_while(ASTNode* body, ASTNode* cond);
ASTNode* make_while(ASTNode* cond, ASTNode* body);

// The magical translation function
void print_as_while(ASTNode* node, ASTNode* current_for_inc);

#endif