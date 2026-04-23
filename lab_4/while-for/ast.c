#include "ast.h"
#include <stdlib.h>
#include <stdio.h>

ASTNode* make_stmt(char* text) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = NODE_STMT; node->raw_text = text; 
    node->init = node->cond = node->inc = node->body = node->next = NULL;
    return node;
}

ASTNode* make_block(ASTNode* body) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = NODE_BLOCK; node->raw_text = NULL;
    node->body = body;
    node->init = node->cond = node->inc = node->next = NULL;
    return node;
}

ASTNode* make_while(ASTNode* cond, ASTNode* body) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = NODE_WHILE; node->cond = cond; node->body = body;
    node->init = node->inc = node->next = NULL;
    return node;
}

ASTNode* make_do_while(ASTNode* body, ASTNode* cond) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = NODE_DO_WHILE; node->body = body; node->cond = cond;
    node->init = node->inc = node->next = NULL;
    return node;
}

ASTNode* make_for(ASTNode* init, ASTNode* cond, ASTNode* inc, ASTNode* body) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = NODE_FOR; node->init = init; node->cond = cond; 
    node->inc = inc; node->body = body; node->next = NULL;
    return node;
}

// --- THE CONVERTER ---
void print_as_for(ASTNode* node) {
    if (!node) return;

    switch (node->type) {
        case NODE_WHILE:
            // Safely convert to a for loop without breaking scope or 'continue'
            printf("for (; ");
            if (node->cond) print_as_for(node->cond); else printf("1");
            printf("; ) {\n");
            print_as_for(node->body);
            printf("}\n");
            break;

        case NODE_DO_WHILE:
            // A do-while translates to an infinite for-loop with a break condition
            printf("for (;;) {\n");
            print_as_for(node->body);
            printf("if (!(");
            print_as_for(node->cond);
            printf(")) break;\n}\n");
            break;

        case NODE_FOR:
            // If the user already wrote a for loop, pass it through untouched
            printf("for (");
            if (node->init) print_as_for(node->init); printf("; ");
            if (node->cond) print_as_for(node->cond); printf("; ");
            if (node->inc) print_as_for(node->inc);
            printf(") {\n");
            print_as_for(node->body);
            printf("}\n");
            break;

        case NODE_STMT:
            printf("%s\n", node->raw_text);
            break;

        case NODE_BLOCK:
            print_as_for(node->body);
            break;
    }

    print_as_for(node->next);
}