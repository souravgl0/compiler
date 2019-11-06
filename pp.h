#ifndef AST_H
#define AST_H
#include "ast.h"
#endif
#include <bits/stdc++.h>
#define PRINT_TABS for(int i=0;i<tabs;i++)cout<<"\t";
using namespace std ;
class ppV: public ASTvisitor
{
public:
    int tabs = 0;
    bool semicolon = true;
    virtual void visit(IntLiteral& node)
    {
        cout<<node.value;
    }
    virtual void visit(DoubleLiteral& node)
    {
        cout<<node.value;
    }
    virtual void visit(StringLiteral& node)
    {
        cout<<node.value;
    }
    virtual void visit(EOFLiteral& node)
    {
        cout<<"EOF";
    }

    virtual void visit(BinaryOp& node)
    {
        ASTnode* left=node.left;
        ASTnode* right=node.right;
        string op=node.op;
        left->accept(*this);
        cout<<" "<<op<<" ";
        right->accept(*this);
    }
    virtual void visit(UnaryOp& node)
    {
        ASTnode* child=node.child;
        string op=node.op;
        cout<<op<<" ";
        child->accept(*this);
    }
    virtual void visit(Identifier& node)
    {
        cout<<node.name;
        if(node.isArray())
        {   cout<<"[";
            node.size1->accept(*this);
            cout<<"]";
        }
        if(node.is2DArray())
        {
            cout<<"[";
            node.size2->accept(*this);
            cout<<"]";
        }
    }
    virtual void visit(ExprList& node)
    {
        vector<ASTnode*> exprs = node.exprs;
        if(exprs.size()!=0)
        {
            exprs[0]->accept(*this);
            auto e = exprs.begin();
            for(e++;e!=exprs.end();e++)
            {
                cout<<", ";
                (*e)->accept(*this);
            }
        }
    }
    virtual void visit(IdentList& node)
    {
        vector<Identifier*> idents = node.idents;
        if(idents.size()!=0)
        {
            idents[0]->accept(*this);
            auto e = idents.begin();
            for(e++;e!=idents.end();e++)
            {
                cout<<", ";
                (*e)->accept(*this);
            }
        }
    }
    virtual void visit(MethodCall& node)
    {
        string name=node.name;
        ExprList* exprlist=node.exprlist;
        cout<<name<<"(";
        exprlist->accept(*this);
        cout<<")";
    }
    virtual void visit(Assignment& node)
    {
        Identifier* left = node.left;
        ASTnode* right = node.right;
        left->accept(*this);
        cout<<" = ";
        right->accept(*this);
    }

    virtual void visit(ScanLine& node)
    {
        IdentList* idents=node.idents;
        cout<<"scan(";
        idents->accept(*this);
        cout<<")";
    }
    virtual void visit(PrintLine& node)
    {
        ExprList* exprs=node.exprs;
        cout<<"print(";
        exprs->accept(*this);
        cout<<")";
    }
    virtual void visit(WFLine& node)
    {
        ASTnode* left=node.left;
    	ASTnode* right=node.right;
        cout<<"writefile(";
        left->accept(*this);
        cout<<", ";
        right->accept(*this);
        cout<<")";
    }
    virtual void visit(RFLine& node)
    {
        string idname = node.idname;
        ASTnode* right=node.right;
        cout<<"readfile("<<idname<<", ";
        right->accept(*this);
        cout<<")";
    }
    virtual void visit(BreakLine& node)
    {
        cout<<"break";
    }
    virtual void visit(ReturnLine& node)
    {
        Identifier* ident=node.ident;
        cout<<"return ";
        ident->accept(*this);
    }
    virtual void visit(VarDecl& node)
    {
        cout<<node.type<<" ";
        node.id->accept(*this);
        if(node.right !=NULL)
        {
            cout<<" = ";
            node.right->accept(*this);
        }
    }
    virtual void visit(Block& node)
    {
        deque<ASTnode*> stmts = node.stmts;

        for(auto aa:stmts)
        {
            if(aa!=NULL)
            {
                PRINT_TABS aa->accept(*this);
                if(semicolon)cout<<";"<<endl;
                else semicolon=true;
            }
            else{
                cout<<"A statement is NULL;"<<endl;
            }
        }
    }
    virtual void visit(ForLoop& node)
    {
        cout<<"for(";
        node.expr1->accept(*this);
        cout<<";";
        node.expr2->accept(*this);
        cout<<";";
        node.expr3->accept(*this);
        cout<<")\n";

        PRINT_TABS cout<<"{\n";
        tabs+=1;
        node.body->accept(*this);
        tabs-=1;
        PRINT_TABS cout<<"}\n";
        semicolon=false;
    }
    virtual void visit(WhileLoop& node)
    {
        cout<<"while(";
        node.cond->accept(*this);
        cout<<")\n";

        PRINT_TABS cout<<"{";
        tabs+=1;
        node.body->accept(*this);
        tabs-=1;
        PRINT_TABS cout<<"}";
        semicolon=false;
    }
    virtual void visit(IFBlock& node)
    {
        ASTnode* cond=node.cond;
        Block* body=node.body;
        if(cond != NULL)
        {
            cout<<"if(";
            cond->accept(*this);
            cout<<")";
        }
        cout<<"\n";
        PRINT_TABS cout<<"{\n";
        tabs+=1;
        body->accept(*this);
        tabs-=1;
        PRINT_TABS cout<<"}\n";
    }
    virtual void visit(Conditional& node)
    {
        IFBlock* ifblk=node.ifblk;
    	deque<IFBlock*> elseifblks=node.elseifblks;
    	IFBlock* elseblk=node.elseblk;

        ifblk->accept(*this);
        for(auto blk:elseifblks)
        {
            PRINT_TABS cout<<"else ";
            blk->accept(*this);
        }
        if(elseblk!=NULL)
        {
            PRINT_TABS cout<<"else";
            elseblk->accept(*this);
        }
        semicolon=false;
    }
    virtual void visit(FunDecl& node)
    {
        string type=node.type;
        Identifier* id=node.id;
        ParamList* params=node.params;
        Block* body=node.body;

        PRINT_TABS cout<<type<<" ";  id->accept(*this); cout<<"("; params->accept(*this); cout<<")\n";
        PRINT_TABS cout<<"{\n";
        tabs+=1;
        body->accept(*this);
        tabs-=1;
        PRINT_TABS cout<<"}\n";
    }
    virtual void visit(ParamList& node)
    {
        vector< pair<string,Identifier*> > params=node.params;
        if(params.size()!=0)
        {
            cout<<params[0].first<<" ";
            (params[0].second)->accept(*this);
            auto e = params.begin();
            for(e++;e!=params.end();e++)
            {
                cout<<", ";
                cout<<e->first<<" ";
                (e->second)->accept(*this);
            }
        }
    }
    virtual void visit(Program& node)
    {
        vector<Block*> blocks = node.blocks;
        vector<FunDecl*> fundecls = node.fundecls;
        for(auto f:fundecls)
        {
            f->accept(*this);
        }
        for(auto b:blocks)
        {
            b->accept(*this);
        }
    }
};
