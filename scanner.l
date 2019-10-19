%{
    #include "parser.hpp"

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
(int|double|uint|string)        { return Type;}
[-]?[0-9]+                      { return IntConstant;}
["](.*)["]                      { return StringConstant;}
[-]?[0-9]+[.][0-9]+             { return DoubleConstant;}
[!]                             { return OP1;}
(!=|==|>=|<=|>>|<<|[\/\+\-\*%><&^|])        {return OP2;}
[a-zA-Z]*                       { return ident;}
.                               { return yytext[0];}

%%
