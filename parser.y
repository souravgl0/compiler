%{
#include <stdio.h>
%}

%token ident OP1 OP2 Type
%token IntConstant DoubleConstant StringConstant EOFkeyword
%token ifkeyword elsekeyword whilekeyword forkeyword breakkeyword
%token returnkeyword printkeyword scankeyword readfilekeyword writefilekeyword
%%

Goal: Program

Program: %empty
        | StmtList Program
        | FuncDecl Program
        ;

StmtCollection: %empty
        | StmtList
        ;

StmtList: Stmt
        | Stmt StmtList
        ;

Stmt: VarDecl
        | WhileStmt
        | BreakStmt
        | PrintStmt
        | ScanStmt
        | IfStmt
        | ForStmt
        | ReturnStmt
        | Expr ';'
        | ReadFileStmt
        | WriteFileStmt
        ;

Expr: ident '=' Expr
        | ident '[' Expr ']' '=' Expr
        | ident '[' Expr ']' '[' Expr ']' '=' Expr
        | ident
        | Expr OP2 Expr
        | OP1 Expr
        | '(' Expr ')'
        | ident '[' Expr ']'
        | ident '[' Expr ']' '[' Expr ']'
        | ident '(' ExprList ')'
        | Constant
        ;

ExprList: %empty
        | ExprCommaList
        ;

ExprCommaList: Expr
        | Expr ',' ExprCommaList
        ;

Constant: IntConstant
        | DoubleConstant
        | StringConstant
        | EOFkeyword
        ;

IfStmt: IfBlock ElseIfStmt ElseStmt

IfBlock: ifkeyword '(' Expr ')' '{' StmtCollection '}'
        ;

ElseIfStmt:  %empty
        | ElseIfBlock ElseIfStmt
        ;

ElseIfBlock: elsekeyword ifkeyword '(' Expr')' '{' StmtCollection '}'
        ;

ElseStmt: %empty
        | ElseBlock
        ;

ElseBlock: elsekeyword '{' StmtCollection '}'
        ;

WhileStmt: whilekeyword '(' Expr ')' '{' StmtCollection '}'
        ;

ForStmt: forkeyword '(' Expr ';' Expr ';' Expr ')' '{' StmtCollection '}'
        ;

BreakStmt: breakkeyword ';'
        ;

ReturnStmt: returnkeyword ident ';'
        | returnkeyword ident '[' Expr ']' ';'
        | returnkeyword ident '[' Expr ']' '[' Expr ']' ';'
        ;

VarDecl: Type ident ';'
        | Type ident '[' Expr ']' ';'
        | Type ident '[' Expr ']' '[' Expr ']' ';'
        | Type ident '=' Expr ';'
        ;

PrintStmt: printkeyword '(' ExprList ')' ';'
        ;

ScanStmt: scankeyword '(' IdentList ')' ';'
        ;

IdentList: %empty
        | IdentCommaList
        ;

IdentCommaList: ident
        | ident '[' Expr ']'
        | ident '[' Expr ']' '[' Expr ']'
        | ident ',' IdentCommaList
        | ident '[' Expr ']' ',' IdentCommaList
        | ident '[' Expr ']' '[' Expr ']' ',' IdentCommaList
        ;

FuncDecl: Type ident '(' ParamList ')' '{' StmtCollection '}'
        ;

ParamList: %empty
        | ParamCommaList
        ;

ParamCommaList: Type ident
        | Type ident '[' ']'
        | Type ident '[' ']' '[' ']'
        | Type ident ',' ParamCommaList
        | Type ident '[' ']' ',' ParamCommaList
        | Type ident '[' ']' '[' ']' ',' ParamCommaList
        ;

ReadFileStmt: readfilekeyword '(' ident ',' Expr ')' ';'
        ;

WriteFileStmt: writefilekeyword '(' Expr ',' Expr ')' ';'
        ;

%%

yyerror(char *s)
{
        fprintf(stderr, "error: %s\n", s);
}


main(int argc, char **argv)
{
        yyparse();
        printf("Parsing Over\n");
		/* Goal:	Expr '\n'

		Expr: 	Expr OP Term
		| Term
		;

		Term:	NUMBER
		| ID
		; */
}
