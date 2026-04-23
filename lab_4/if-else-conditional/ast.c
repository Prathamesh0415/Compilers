#include "ast.h"
#include <stdlib.h>
#include <stdio.h>

ASTNode* make_stmt(char* text) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = NODE_STMT; node->raw_text = text; 
    node->cond = node->body = node->else_body = node->next = NULL;
    return node;
}

ASTNode* make_block(ASTNode* body) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = NODE_BLOCK; node->raw_text = NULL;
    node->body = body;
    node->cond = node->else_body = node->next = NULL;
    return node;
}

ASTNode* make_if(ASTNode* cond, ASTNode* body, ASTNode* else_body) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = NODE_IF; node->raw_text = NULL;
    node->cond = cond; node->body = body; node->else_body = else_body;
    node->next = NULL;
    return node;
}

// --- EXPRESSION PRINTER (No Semicolons Allowed!) ---
void print_ternary_expr(ASTNode* node) {
    if (!node) return;

    if (node->type == NODE_IF) {
        // Enforce precedence with heavy parentheses: (cond) ? (true) : (false)
        printf("(");
        print_ternary_expr(node->cond);
        printf(") ? (");
        print_ternary_expr(node->body);
        printf(") : (");
        
        if (node->else_body) print_ternary_expr(node->else_body);
        else printf("0"); // If there is no 'else', C requires a dummy value
        
        printf(")");
    } 
    else if (node->type == NODE_STMT) {
        printf("%s", node->raw_text); // Print exactly as is (No semicolon!)
    } 
    else if (node->type == NODE_BLOCK) {
        // Convert a block { x=1; y=2; } into a comma expression: x=1, y=2
        ASTNode* curr = node->body;
        while (curr) {
            print_ternary_expr(curr);
            if (curr->next) printf(", ");
            curr = curr->next;
        }
    }
}

// --- TOP LEVEL PRINTER (Safe to print Semicolons) ---
void convert_to_ternary(ASTNode* node) {
    if (!node) return;

    if (node->type == NODE_IF) {
        print_ternary_expr(node);
        printf(";\n"); // Cap off the massive ternary expression
    } 
    else if (node->type == NODE_STMT) {
        printf("%s;\n", node->raw_text); 
    } 
    else if (node->type == NODE_BLOCK) {
        convert_to_ternary(node->body);
    }

    convert_to_ternary(node->next);
}