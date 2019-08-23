%{
    #include <iostream>
    using namespace std;
    extern int yylex();
%}
%%

[w][h][i][l][e][ \t\n]* {cout<<"WHILE ";}
[\(][ \t\n]* {cout<<"LEFT("<<"\n";}
[\)][ \t\n]* {cout<<"RIGHT)"<<"\n";}
[\{][ \t\n]* {cout<<"LEFT{"<<"\n";}
[\}][ \t\n]* {cout<<"RIGHT}"<<"\n";}
[i][n][t][ \t\n]* {cout<<"INT\n";}
[f][l][o][a][t][ \t\n]* {cout<<"FLOAT\n";}
[a-zA-Z]+[ \t\n]* {cout<<"NAME: "<<yytext<<"\n";}
[\;][ \t\n]* {cout<<"LINEBREAK\n";}

%%

int main()
{
    while(yylex());
}
