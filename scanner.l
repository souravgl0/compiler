%{
    #include "parser.tab.h"
    /* extern "C" int yylex(); */
    /* extern "C" void yyerror(); */
    /* extern int yylex(); */
%}

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

/*
int main()
{
[i][f] {return i;}
[a] {return a;}
[e][l][s][e] {return e;}
[w][h][i][l][e][ \t\n]* {return WHILE;}
    while(yylex());
    [\(][ \t\n]* {cout<<"LEFT("<<"\n";}
    [\)][ \t\n]* {cout<<"RIGHT)"<<"\n";}
    [\{][ \t\n]* {cout<<"LEFT{"<<"\n";}
    [\}][ \t\n]* {cout<<"RIGHT}"<<"\n";}
    [i][n][t][ \t\n]* {cout<<"INT\n";}
    [f][l][o][a][t][ \t\n]* {cout<<"FLOAT\n";}
    [a-zA-Z]+[ \t\n]* {cout<<"NAME: "<<yytext<<"\n";}
    [\;][ \t\n]* {cout<<"LINEBREAK\n";}
} */
