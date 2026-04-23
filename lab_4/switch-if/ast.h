#ifndef AST_H
#define AST_H

typedef enum { 
    NODE_SWITCH, 
    NODE_CASE, 
    NODE_DEFAULT, 
    NODE_STMT, 
    NODE_BREAK 
} NodeType;

typedef struct ASTNode {
    NodeType type;
    char* raw_text;             
    
    struct ASTNode* cond; // Holds the Switch variable (e.g., 'x') OR the Case value (e.g., '1')
    struct ASTNode* body; // The statements inside the case
    
    struct ASTNode* next; // Pointer to the next case or next statement
} ASTNode;

// Function Prototypes
ASTNode* make_stmt(char* text);
ASTNode* make_keyword(NodeType type);
ASTNode* make_switch(ASTNode* cond, ASTNode* body);
ASTNode* make_case(ASTNode* val, ASTNode* body);
ASTNode* make_default(ASTNode* body);

// The magical translation function
void print_as_if(ASTNode* node, ASTNode* current_switch_cond, int* is_first_case);

#endif