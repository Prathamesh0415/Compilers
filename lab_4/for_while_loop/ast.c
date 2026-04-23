#include "ast.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

ASTNode* make_stmt(char* text) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = NODE_STMT;
    node->raw_text = text; 
    node->init = node->cond = node->inc = node->body = node->next = NULL;
    return node;
}

ASTNode* make_keyword(NodeType type) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = type;
    node->raw_text = NULL;
    node->init = node->cond = node->inc = node->body = node->next = NULL;
    return node;
}

ASTNode* make_for(ASTNode* init, ASTNode* cond, ASTNode* inc, ASTNode* body) {
    ASTNode* node = make_keyword(NODE_FOR);
    node->init = init; node->cond = cond; node->inc = inc; node->body = body;
    return node;
}

ASTNode* make_do_while(ASTNode* body, ASTNode* cond) {
    ASTNode* node = make_keyword(NODE_DO_WHILE);
    node->body = body; node->cond = cond;
    return node;
}

ASTNode* make_while(ASTNode* cond, ASTNode* body) {
    ASTNode* node = make_keyword(NODE_WHILE);
    node->cond = cond; node->body = body;
    return node;
}

void print_as_while(ASTNode* node, ASTNode* current_for_inc) {
    if (!node) return;

    switch (node->type) {
        case NODE_FOR:
            if (node->init) { print_as_while(node->init, NULL); printf(";\n"); }

            printf("while (");
            if (node->cond) print_as_while(node->cond, NULL); else printf("1");
            printf(") {\n");

            print_as_while(node->body, node->inc);

            if (node->inc) { print_as_while(node->inc, NULL); printf(";\n"); }
            printf("}\n");
            break;

        case NODE_DO_WHILE:
            printf("while (1) {\n");
            print_as_while(node->body, NULL);
            printf("if (!(");
            print_as_while(node->cond, NULL);
            printf(")) break;\n}\n");
            break;

        case NODE_WHILE:
            printf("while (");
            print_as_while(node->cond, NULL);
            printf(") {\n");
            print_as_while(node->body, NULL);
            printf("}\n");
            break;

        case NODE_CONTINUE:
            if (current_for_inc) { print_as_while(current_for_inc, NULL); printf(";\n"); }
            printf("continue;\n");
            break;

        case NODE_BREAK:
            printf("break;\n");
            break;

        case NODE_STMT:
            printf("%s", node->raw_text);
            break;
    }

    print_as_while(node->next, current_for_inc);
}