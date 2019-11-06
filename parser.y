%{
/* #include <iostream> */
#include "scanner.hpp"
#include <bits/stdc++.h>
using namespace std;

#ifndef AST_H
#define AST_H
#include "ast.h"
#endif
#ifndef PP_H
#define PP_H
#include "pp.h"
#endif
extern ASTnode *head;
ppV po;
ASTnode *tz = new IntLiteral(0);
extern int yylex();
extern void yyerror(char*);

%}

%union{
    int integerVal;
    float doubleVal;
    std::string* stringVal;
    class ASTnode* astnode;
}
%type <astnode> Goal Program StmtCollection StmtList Stmt Expr ExprList ExprCommaList Constant IfStmt IfBlock ElseIfStmt ElseIfBlock ElseStmt ElseBlock WhileStmt ForStmt BreakStmt ReturnStmt VarDecl PrintStmt ScanStmt IdentList IdentCommaList FuncDecl ParamList ParamCommaList ReadFileStmt WriteFileStmt
%token <stringVal> ident Type
%token <stringVal> OP2 OP1
%token <integerVal>IntConstant
%token <doubleVal>DoubleConstant
%token <stringVal>StringConstant
%token EOFkeyword
%token ifkeyword elseifkeyword elsekeyword whilekeyword forkeyword breakkeyword
%token returnkeyword printkeyword scankeyword readfilekeyword writefilekeyword
%%

Goal: Program {head = $1; head->accept(po);}

Program: StmtList {Program* p = new Program(); p->add(dynamic_cast<Block*>($1));$$=p;}
        | FuncDecl {Program* p = new Program(); p->add(dynamic_cast<FunDecl*>($1));$$=p;}
        | StmtList Program {Program* p = dynamic_cast<Program*>($2); p->add(dynamic_cast<Block*>($1));$$=p;}
        | FuncDecl Program {Program* p = dynamic_cast<Program*>($2); p->add(dynamic_cast<FunDecl*>($1));$$=p;}
        ;

StmtCollection: %empty {$$ = new Block();}
        | StmtList {Block* t = dynamic_cast<Block*>($1); $$ = $1;}
        ;

StmtList: Stmt {Block* t = new Block(); t->add($1); $$ = t;}
        | Stmt StmtList {Block* t = dynamic_cast<Block*>($2); t->add($1); $$ = t;}
        ;

Stmt: VarDecl {$$ = $1;}
        | WhileStmt {$$ = $1;}
        | BreakStmt {$$ = $1;}
        | PrintStmt {$$ = $1;}
        | ScanStmt {$$ = $1;}
        | IfStmt {$$ = $1;}
        | ForStmt {$$ = $1;}
        | ReturnStmt {$$ = $1;}
        | Expr ';' {$$ = $1;}
        | ReadFileStmt {$$ = $1;}
        | WriteFileStmt {$$ = $1;}
        ;

Expr: ident '=' Expr {Identifier* t = new Identifier(*$1); $$ = new Assignment(t,$3);}
        | ident '[' Expr ']' '=' Expr {Identifier* t = new Identifier(*$1,$3); $$ = new Assignment(t,$6);}
        | ident '[' Expr ']' '[' Expr ']' '=' Expr {Identifier* t = new Identifier(*$1,$3,$6); $$ = new Assignment(t,$9);}
        | ident {$$ = new Identifier(*$1);}
        | Expr OP2 Expr {$$ = new BinaryOp(*$2, $1, $3);}
        | OP1 Expr {$$ = new UnaryOp(*$1, $2);}
        | '(' Expr ')' {$$ = $2;}
        | ident '[' Expr ']' {$$ = new Identifier(*$1, $3);}
        | ident '[' Expr ']' '[' Expr ']' {$$ = new Identifier(*$1, $3, $6);}
        | ident '(' ExprList ')' {ExprList *t = dynamic_cast<ExprList*>($3) ; $$ = new MethodCall(t, *$1);}
        | Constant {$$ = $1;}
        ;

ExprList: %empty {$$ = new ExprList();}
        | ExprCommaList {$$ = $1;}
        ;

ExprCommaList: Expr {ExprList* t = new ExprList(); t->add($1); $$ = t;}
        | ExprCommaList ',' Expr {ExprList* t = dynamic_cast<ExprList*>($1); t->add($3); $$ = t;}
        ;

Constant: IntConstant {$$ = new IntLiteral($1);}
        | DoubleConstant {$$ = new DoubleLiteral($1);}
        | StringConstant {$$ = new StringLiteral(*$1);}
        | EOFkeyword {$$ = new EOFLiteral();}
        ;

IfStmt: IfBlock ElseIfStmt ElseStmt {
        Conditional* c = dynamic_cast<Conditional*>($2);
        c->ifblk = dynamic_cast<IFBlock*>($1);
        if($3!=NULL)
            c->elseblk = dynamic_cast<IFBlock*>($3);
        else
            c->elseblk = NULL;
        $$=c;
    }

IfBlock: ifkeyword '(' Expr ')' '{' StmtCollection '}' {$$ = new IFBlock(dynamic_cast<Block*>($6),$3);}
        ;

ElseIfStmt:  %empty {$$ = new Conditional();}
        | ElseIfBlock ElseIfStmt {Conditional* c = dynamic_cast<Conditional*>($2); IFBlock* i = dynamic_cast<IFBlock*>($1);c->add(i);$$=c;}
        ;

ElseIfBlock: elseifkeyword '(' Expr')' '{' StmtCollection '}' {$$ = new IFBlock(dynamic_cast<Block*>($6),$3);}
        ;

ElseStmt: %empty {$$ = NULL;}
        | ElseBlock {$$ = $1;}
        ;

ElseBlock: elsekeyword '{' StmtCollection '}' {$$ = new IFBlock(dynamic_cast<Block*>($3));}
        ;

WhileStmt: whilekeyword '(' Expr ')' '{' StmtCollection '}' {$$ = new WhileLoop($3,dynamic_cast<Block*>($6));}
        ;

ForStmt: forkeyword '(' Expr ';' Expr ';' Expr ')' '{' StmtCollection '}' {$$ = new ForLoop($3,$5,$7,dynamic_cast<Block*>($10));}
        ;

BreakStmt: breakkeyword ';' {$$ = new BreakLine();}
        ;

ReturnStmt: returnkeyword ident ';' {Identifier* t = new Identifier(*$2); $$ = new ReturnLine(t);}
        | returnkeyword ident '[' Expr ']' ';' {Identifier* t = new Identifier(*$2,$4); $$ = new ReturnLine(t);}
        | returnkeyword ident '[' Expr ']' '[' Expr ']' ';' {Identifier* t = new Identifier(*$2,$4,$7); $$ = new ReturnLine(t);}
        ;

VarDecl: Type ident ';' {Identifier* t = new Identifier(*$2); $$ = new VarDecl(*$1,t);}
        | Type ident '[' Expr ']' ';'  {Identifier* t = new Identifier(*$2,$4); $$ = new VarDecl(*$1,t);}
        | Type ident '[' Expr ']' '[' Expr ']' ';' {Identifier* t = new Identifier(*$2,$4,$7); $$ = new VarDecl(*$1,t);}
        | Type ident '=' Expr ';'  {Identifier* t = new Identifier(*$2); $$ = new VarDecl(*$1,t,$4);}
        ;

PrintStmt: printkeyword '(' ExprList ')' ';' {ExprList* t = dynamic_cast<ExprList*> ($3) ;$$ = new PrintLine(t);}
        ;

ScanStmt: scankeyword '(' IdentList ')' ';' {IdentList* t = dynamic_cast<IdentList*> ($3) ;$$ = new ScanLine(t);}
        ;

IdentList: %empty {$$ = new IdentList();}
        | IdentCommaList {$$ = $1;}
        ;

IdentCommaList: ident {IdentList* l = new IdentList(); Identifier* t = new Identifier(*$1); l->add(t); $$ = l;}
        | ident '[' Expr ']' {IdentList* l = new IdentList(); Identifier* t = new Identifier(*$1,$3); l->add(t); $$ = l;}
        | ident '[' Expr ']' '[' Expr ']' {IdentList* l = new IdentList(); Identifier* t = new Identifier(*$1,$3,$6); l->add(t); $$ = l;}
        | IdentCommaList ',' ident {Identifier* t = new Identifier(*$3); IdentList* l = dynamic_cast<IdentList*>($1); l->add(t); $$ = l;}
        | IdentCommaList ',' ident '[' Expr ']'  {Identifier* t = new Identifier(*$3,$5); IdentList* l = dynamic_cast<IdentList*>($1); l->add(t); $$ = l;}
        | IdentCommaList ',' ident '[' Expr ']' '[' Expr ']'  {Identifier* t = new Identifier(*$3,$5,$8); IdentList* l = dynamic_cast<IdentList*>($1); l->add(t); $$ = l;}
        ;

FuncDecl: Type ident '(' ParamList ')' '{' StmtCollection '}' {$$ = new FunDecl(*$1,new Identifier(*$2),dynamic_cast<ParamList*>($4),dynamic_cast<Block*>($7));}
        ;

ParamList: %empty {$$ = new ParamList();}
        | ParamCommaList {$$ = $1;}
        ;

ParamCommaList: Type ident {ParamList* p = new ParamList(); p->add(*$1, new Identifier(*$2)); $$ = p;}
        | Type ident '[' ']' {ParamList* p = new ParamList(); p->add(*$1, new Identifier(*$2,tz)); $$ = p;}
        | Type ident '[' ']' '[' ']' {ParamList* p = new ParamList(); p->add(*$1, new Identifier(*$2,tz,tz)); $$ = p;}
        | Type ident ',' ParamCommaList {ParamList* p = dynamic_cast<ParamList*>($4); p->add(*$1, new Identifier(*$2)); $$ = p;}
        | Type ident '[' ']' ',' ParamCommaList {ParamList* p = dynamic_cast<ParamList*>($6); p->add(*$1, new Identifier(*$2,tz)); $$ = p;}
        | Type ident '[' ']' '[' ']' ',' ParamCommaList {ParamList* p = dynamic_cast<ParamList*>($8); p->add(*$1, new Identifier(*$2,tz,tz)); $$ = p;}
        ;

ReadFileStmt: readfilekeyword '(' ident ',' Expr ')' ';' {$$ = new RFLine(*$3,$5);}
        ;

WriteFileStmt: writefilekeyword '(' Expr ',' Expr ')' ';' {$$ = new WFLine($3,$5);}
        ;

%%

void yyerror(char *s)
{
        fprintf(stderr, "error: %s\n", s);
}
