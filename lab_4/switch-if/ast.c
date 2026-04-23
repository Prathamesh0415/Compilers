#include "ast.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

ASTNode* make_stmt(char* text) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = NODE_STMT; node->raw_text = text; 
    node->cond = node->body = node->next = NULL;
    return node;
}

ASTNode* make_keyword(NodeType type) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = type; node->raw_text = NULL;
    node->cond = node->body = node->next = NULL;
    return node;
}

ASTNode* make_switch(ASTNode* cond, ASTNode* body) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = NODE_SWITCH; node->raw_text = NULL;
    node->cond = cond; node->body = body; node->next = NULL;
    return node;
}

ASTNode* make_case(ASTNode* val, ASTNode* body) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = NODE_CASE; node->raw_text = NULL;
    node->cond = val; node->body = body; node->next = NULL;
    return node;
}

ASTNode* make_default(ASTNode* body) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = NODE_DEFAULT; node->raw_text = NULL;
    node->cond = NULL; node->body = body; node->next = NULL;
    return node;
}

// --- The Converter ---
void print_as_if(ASTNode* node, ASTNode* current_switch_cond, int* is_first_case) {
    if (!node) return;

    switch (node->type) {
        case NODE_SWITCH: {
            // A new switch block starts! 
            // We set 'first_case' to 1 so the first case prints 'if' instead of 'else if'
            int first = 1;
            print_as_if(node->body, node->cond, &first);
            break;
        }

        case NODE_CASE:
            if (*is_first_case) {
                printf("if (%s == %s) {\n", current_switch_cond->raw_text, node->cond->raw_text);
                *is_first_case = 0; // Turn off the flag for the next cases
            } else {
                printf("else if (%s == %s) {\n", current_switch_cond->raw_text, node->cond->raw_text);
            }
            
            // Print the code inside the case. We pass NULL for switch_cond so nested switches don't get confused!
            print_as_if(node->body, NULL, NULL);
            printf("}\n");
            break;

        case NODE_DEFAULT:
            printf("else {\n");
            print_as_if(node->body, NULL, NULL);
            printf("}\n");
            break;

        case NODE_BREAK:
            // THE FIX: If we are converting a switch, an if-else chain naturally breaks itself.
            // Therefore, we completely ignore and drop the break statement!
            // (Note: If this was inside a while loop, we would print it, but for Problem 2 we drop it).
            break;

        case NODE_STMT:
            printf("%s\n", node->raw_text);
            break;
    }

    // Traverse to the next statement or case in the linked list
    print_as_if(node->next, current_switch_cond, is_first_case);
}