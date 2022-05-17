%{ 
#include<stdio.h>
#include "y.tab.h"
extern int yylval;
int Qflag = 0; //flag for quotation mark
%}


%%
[a][n][d]                   return TOKEN_KW_AND;
[o][r]                      return TOKEN_KW_OR;
[n][o][t]                   return TOKEN_KW_NOT;
[e][q][u][a][l]             return TOKEN_KW_EQUAL;
[l][e][s][s]                return TOKEN_KW_LESS;
[n][i][l]                   return TOKEN_KW_NIL;
[l][i][s][t]                return TOKEN_KW_LIST;
[a][p][p][e][n][d]          return TOKEN_KW_APPEND;
[c][o][n][c][a][t]          return TOKEN_KW_CONCAT;
[s][e][t]                   return TOKEN_KW_SET;
[d][e][f][f][u][n]          return TOKEN_KW_DEFFUN;
[d][e][f][v][a][r]          return TOKEN_KW_DEFVAR;
[f][o][r]                   return TOKEN_KW_FOR;
[i][f]                      return TOKEN_KW_IF;
[e][x][i][t]                return TOKEN_KW_EXIT;
[l][o][a][d]                return TOKEN_KW_LOAD;
[d][i][s][p]                return TOKEN_KW_DISP;
[t][r][u][e]                return TOKEN_KW_TRUE;
[f][a][l][s][e]             return TOKEN_KW_FALSE;

[+]                         return TOKEN_OP_PLUS;
[-]                         return TOKEN_OP_MINUS;
[/]                         return TOKEN_OP_DIV;
[*]                         return TOKEN_OP_MULT;
[(]                         return TOKEN_OP_OP;
[)]                         return TOKEN_OP_CP;
[*][*]                      return TOKEN_OP_DBLMULT;
["]                         {
                                if(Qflag == 0){
                                    Qflag = 1;
                                    return TOKEN_OP_OC;
                                } else {
                                    Qflag = 0;
                                    return TOKEN_OP_CC;
                                }
                            }
[,]                         return TOKEN_OP_COMMA;

[0]|[1-9][0-9]*             {
                                yylval=atoi(yytext); 
                                return TOKEN_INTEGER_VALUE; 
                            }

[;][;].*                    return TOKEN_COMMENT;
[a-zA-Z_][a-zA-Z0-9_]*      return TOKEN_IDENTIFIER;
['][(]                      return TOKEN_LISTOP;
[a-zA-Z0-9_]*[.][a-z]*      return TOKEN_FLE;

[\t]|[ ]                    { } 
[\n]                        {printf("%s",yytext); return 0; }
.                           {yyerror("invalid token");} 
%%