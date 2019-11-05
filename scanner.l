%{
    #include <bits/stdc++.h>
    using namespace std ;

    #include "parser.hpp"
    #include "ast.h"
    #define store_string yylval.stringVal = new string(yytext,yyleng)

%}

%option outfile="scanner.cpp" header-file="scanner.hpp"

%%
[ \t\n] 		              	{ /* eat white spaces */  }
(if)                            { return ifkeyword;}
(else)                          { return elsekeyword;}
(while)                         { return whilekeyword;}
(for)                           { return forkeyword;}
(break)                         { return breakkeyword;}
(return)                        { return returnkeyword;}
(print)                         { return printkeyword;}
(scan)                          { return scankeyword;}
(readfile)                      { return readfilekeyword;}
(writefile)                     { return writefilekeyword;}
(EOF)                           { return EOFkeyword;}
(int|double|uint|string)        { store_string; return Type;}
[-]?[0-9]+                      { yylval.integerVal = atoi(yytext); return IntConstant;}
["](.*)["]                      { store_string ; return StringConstant;}
[-]?[0-9]+[.][0-9]+             { yylval.doubleVal = atof(yytext); return DoubleConstant;}
[!]                             { store_string; return OP1;}
(!=|==|>=|<=|>>|<<|[\/\+\-\*%><&^|])        {store_string ; return OP2;}
[a-zA-Z]*                       { store_string ; return ident;}
.                               { return yytext[0];}

%%
