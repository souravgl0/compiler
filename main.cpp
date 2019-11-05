#include <bits/stdc++.h>
#ifndef AST_H
#define AST_H
#include "ast.h"
#endif
#ifndef PP_H
#define PP_H
#include "pp.h"
#endif

using namespace std;

extern int yyparse();
extern int topval;
ASTnode *head;
// extern ASTnode* programBlock;

// void createCoreFunctions(CodeGenContext& context);

int main(int argc, char **argv)
{
	yyparse();
    printf("Parsing Over\n");

	// ppV po;
	// head->accept(po);
    // printf("this: %d\n",topval);
	// PostFixVisitor pfv ;
	// IRGen igen;
	// pfv.visit(*dynamic_cast<Program*>(programBlock)) ;
	// if(pfv.hasError()) return 0 ;
	// igen.visit(*dynamic_cast<Program*>(programBlock));
	// ModuleOb->dump();
	// cout << programBlock << endl;
	// InitializeNativeTarget();
	// InitializeNativeTargetAsmPrinter();
	// InitializeNativeTargetAsmParser();
	// CodeGenContext context;
	// createCoreFunctions(context);
	// context.generateCode(*programBlock);
	// context.runCode();

	return 0;
}
