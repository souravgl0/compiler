#include <bits/stdc++.h>

using namespace std;

class Program;
class FunDecl;
class ParamList;
class IFBlock;
class Conditional;
class WhileLoop;
class ForLoop;
class Block;
class VarDecl;
class ReturnLine;
class BreakLine;
class WFLine;
class RFLine;
class PrintLine;
class ScanLine;
class Assignment;
class MethodCall;
class ExprList;
class IdentList;
class Identifier;
class UnaryOp;
class BinaryOp;
class IntLiteral;
class DoubleLiteral;
class StringLiteral;
class EOFLiteral;
class Constant;

class ASTnode;

class ASTvisitor
{
	public:
		virtual void visit(Program& node) = 0;
		virtual void visit(FunDecl& node) = 0;
		virtual void visit(ParamList& node) = 0;
		virtual void visit(IFBlock& node) = 0;
		virtual void visit(Conditional& node) = 0;
		virtual void visit(WhileLoop& node) = 0;
		virtual void visit(ForLoop& node) = 0;
		virtual void visit(Block& node) = 0;
		virtual void visit(VarDecl& node) = 0;
		virtual void visit(ReturnLine& node) = 0;
		virtual void visit(BreakLine& node) = 0;
		virtual void visit(WFLine& node) = 0;
		virtual void visit(RFLine& node) = 0;
		virtual void visit(PrintLine& node) = 0;
		virtual void visit(ScanLine& node) = 0;
		virtual void visit(Assignment& node) = 0;
		virtual void visit(MethodCall& node) = 0;
		virtual void visit(ExprList& node) = 0;
		virtual void visit(IdentList& node) = 0;
		virtual void visit(Identifier& node) = 0;
		virtual void visit(UnaryOp& node) = 0;
		virtual void visit(BinaryOp& node) = 0;
        virtual void visit(IntLiteral& node) = 0;
        virtual void visit(DoubleLiteral& node) = 0;
		virtual void visit(StringLiteral& node) = 0;
        virtual void visit(EOFLiteral& node) = 0;

};

class ASTnode
{
	public:
		virtual ~ASTnode() {}
		virtual void accept(ASTvisitor& V) = 0;
};
// code starts
class Constant : public ASTnode
{
	virtual void accept(ASTvisitor& V) = 0;
};
class IntLiteral : public Constant
{
	public:
		int value;
		IntLiteral(int v)
		{
			// cout<<v<<endl;
			value = v;
        }
		virtual void accept(ASTvisitor& V)
		{
			V.visit(*this);
		}
};
class DoubleLiteral : public Constant
{
	public:
		float value;
		DoubleLiteral(float v)
		{
			value = v;
        }
		virtual void accept(ASTvisitor& V)
		{
			V.visit(*this);
		}
};
class StringLiteral : public Constant
{
	public:
		string value;
		StringLiteral(string v)
		{
			value = v;
        }
		virtual void accept(ASTvisitor& V)
		{
			V.visit(*this);
		}
};

class EOFLiteral : public Constant
{
	public:
		EOFLiteral(){}
		virtual void accept(ASTvisitor& V)
		{
			V.visit(*this);
		}
};

class BinaryOp : public ASTnode
{
	public :
	ASTnode* left;
	ASTnode* right;
	string op;
	BinaryOp(string ope, ASTnode* l1, ASTnode* r1)
	{
		// cout<<l1<<" "<<ope<<endl;
		left = l1;right = r1;op = ope;
	}
	virtual void accept(ASTvisitor& V)
	{
		V.visit(*this);
	}
};

class UnaryOp : public ASTnode
{
	public :
		string op;
		ASTnode* child;
		UnaryOp(string ope, ASTnode* l)
		{
			op = ope;child = l;
		}
		virtual void accept(ASTvisitor& V)
		{
			V.visit(*this);
		}
};

class Identifier : public ASTnode
{
	public :
		string name;
		ASTnode* size1;
		ASTnode* size2;
		Identifier(string _t, ASTnode* s1 = NULL, ASTnode* s2 = NULL)
		{
			name = _t;
			size1 = s1;
			size2 = s2;
		}
		bool isArray()
		{
			return size1!=NULL;
		}
		bool is2DArray()
		{
			return size1!=NULL && size2!=NULL;
		}
		virtual void accept(ASTvisitor& V)
		{
			V.visit(*this);
		}
};

class ExprList : public ASTnode
{
	public :
		vector< ASTnode* > exprs;
		void add(ASTnode* a)
		{
			exprs.push_back(a);
		}
		virtual void accept(ASTvisitor& V)
		{
			V.visit(*this);
		}

		// void pp(){
		// 	for(auto aa:exprs)
		// 	{
		// 		Identifier * ab = dynamic_cast<Identifier*> (aa);
		// 		cout<<ab->name<<"  ;; ";
		// 	}
		// 	cout<<endl;
		// }
};

class IdentList : public ASTnode
{
	public :
		vector< Identifier* > idents;
		void add(Identifier* a)
		{
			idents.push_back(a);
		}
		virtual void accept(ASTvisitor& V)
		{
			V.visit(*this);
		}

		// void pp(){
		// 	for(auto aa:exprs)
		// 	{
		// 		Identifier * ab = dynamic_cast<Identifier*> (aa);
		// 		cout<<ab->name<<"  ;; ";
		// 	}
		// 	cout<<endl;
		// }
};

class MethodCall : public ASTnode
{
	public :
		string name;
		ExprList* exprlist;

		MethodCall(ExprList* a, string n)
		{
			name = n;
			exprlist = a;
		}
		virtual void accept(ASTvisitor& V)
		{
			V.visit(*this);
		}
};

class Assignment : public ASTnode
{
	public :
	Identifier* left;
	ASTnode* right;
	Assignment(Identifier* l, ASTnode* r)
	{
		left = l;right = r;
	}
	virtual void accept(ASTvisitor& V)
	{
		V.visit(*this);
	}
};

class ScanLine : public ASTnode
{
	public :
	IdentList* idents;
	ScanLine(IdentList* l)
	{
		idents = l;
	}
	virtual void accept(ASTvisitor& V)
	{
		V.visit(*this);
	}
};

class PrintLine : public ASTnode
{
	public :
	ExprList* exprs;
	PrintLine(ExprList* l)
	{
		exprs = l;
	}
	virtual void accept(ASTvisitor& V)
	{
		V.visit(*this);
	}
};

class WFLine : public ASTnode
{
	public :
	ASTnode* left;
	ASTnode* right;
	WFLine(ASTnode* l, ASTnode* r)
	{
		left = l; right = r;
	}
	virtual void accept(ASTvisitor& V)
	{
		V.visit(*this);
	}
};

class RFLine : public ASTnode
{
	public :
	string idname;
	ASTnode* right;
	RFLine(string i, ASTnode* r)
	{
		idname = i; right = r;
	}
	virtual void accept(ASTvisitor& V)
	{
		V.visit(*this);
	}
};

class BreakLine : public ASTnode
{
	virtual void accept(ASTvisitor& V)
	{
		V.visit(*this);
	}
};

class ReturnLine : public ASTnode
{
	public :
	Identifier* ident;
	ReturnLine(Identifier* i)
	{
		ident = i;
	}
	virtual void accept(ASTvisitor& V)
	{
		V.visit(*this);
	}
};

class VarDecl : public ASTnode
{
	public :
		string type;
		Identifier* id;
		ASTnode* right;
		VarDecl(string t, Identifier* n, ASTnode* r = NULL)
		{
			type = t; id = n; right = r;
		}
		bool isInitialized()
		{
			return right!=NULL;
		}
		virtual void accept(ASTvisitor& V)
		{
				V.visit(*this);
		}
};

class Block : public ASTnode
{
	public :
		deque< ASTnode* > stmts;
		void add(ASTnode* a)
		{
			stmts.push_front(a);
		}
		virtual void accept(ASTvisitor& V)
		{
			V.visit(*this);
		}

		// void pp(){
		// 	for(auto aa:stmts)
		// 	{
		// 		try{
		// 			VarDecl * ab = dynamic_cast<VarDecl*> (aa);
		// 			// if(ab->type)cout<<ab->type<<"  ;; ";
		// 		}
		// 		catch(int e){
		//
		// 		}
		// 	}
		// 	cout<<endl;
		// }
};
class ForLoop : public ASTnode
{
	public :
	ASTnode* expr1;
	ASTnode* expr2;
	ASTnode* expr3;
	Block* body;
	ForLoop(ASTnode* e1,ASTnode* e2, ASTnode* e3, Block* b)
	{
		expr1=e1;
		expr2=e2;
		expr3=e3;
		body = b;
	}
	virtual void accept(ASTvisitor& V)
	{
		V.visit(*this);
	}
};
class WhileLoop : public ASTnode
{
	public :
	ASTnode* cond;
	Block* body;
	WhileLoop(ASTnode* c, Block* b)
	{
		cond = c;
		body = b;
	}
	virtual void accept(ASTvisitor& V)
	{
		V.visit(*this);
	}
};

class IFBlock : public ASTnode
{
	public:
	ASTnode* cond;
	Block* body;
	IFBlock(Block* b, ASTnode* c = NULL)
	{
		cond = c; body = b;
	}
	virtual void accept(ASTvisitor& V)
	{
		V.visit(*this);
	}
};
class Conditional : public ASTnode
{
	public:
	IFBlock* ifblk;
	deque<IFBlock*> elseifblks;
	IFBlock* elseblk;

	void add(IFBlock* i)
	{
		elseifblks.push_front(i);
	}
	virtual void accept(ASTvisitor& V)
	{
		V.visit(*this);
	}
};

class FunDecl : public ASTnode
{
	public :
		string type;
		Identifier* id;
		ParamList* params;
		Block* body;
		FunDecl(string t, Identifier* n, ParamList* p, Block* b)
		{
			type = t; id = n; params = p; body = b;
		}
		virtual void accept(ASTvisitor& V)
		{
				V.visit(*this);
		}
};

class ParamList : public ASTnode
{
	public:

	vector< pair<string,Identifier*> > params;
	void add(string s, Identifier* i)
	{
		params.push_back(make_pair(s,i));
	}
	virtual void accept(ASTvisitor& V)
	{
			V.visit(*this);
	}
};

class Program: public ASTnode
{
	public:
		vector<Block*> blocks;
		vector<FunDecl*> fundecls;
		void add(Block* b)
		{
			blocks.push_back(b);
		}
		void add(FunDecl* f)
		{
			fundecls.push_back(f);
		}
		virtual void accept(ASTvisitor& V)
		{
				V.visit(*this);
		}
};
