%{ 
#include <stdio.h>
#include <string.h>
#include "tokens.h"

const char tokensStrArr[][15] = { "", "KW_AND", "KW_OR", "KW_NOT", "KW_EQUAL", "KW_LESS", "KW_NIL", "KW_LIST", "KW_APPEND", "KW_CONCAT", "KW_SET", "KW_DEFFUN", "KW_FOR",
						  "KW_IF", "KW_EXIT", "KW_LOAD", "KW_DISP", "KW_TRUE", "KW_FALSE", "OP_PLUS", "OP_MINUS", "OP_DIV", "OP_MULT", "OP_OP", "OP_CP", "OP_DBLMULT",
						  "OP_OC", "OP_CC", "OP_COMMA", "COMMENT", "VALUE", "IDENTIFIER"};
int Qflag = 0;
%} 

%%
[a][n][d]					return TOKEN_KW_AND;
[o][r]						return TOKEN_KW_OR;
[n][o][t]					return TOKEN_KW_NOT;
[e][q][u][a][l] 			return TOKEN_KW_EQUAL;
[l][e][s][s]				return TOKEN_KW_LESS;
[n][i][l]					return TOKEN_KW_NIL;
[l][i][s][t]				return TOKEN_KW_LIST;
[a][p][p][e][n][d]			return TOKEN_KW_APPEND;
[c][o][n][c][a][t]			return TOKEN_KW_CONCAT;
[s][e][t]					return TOKEN_KW_SET;
[d][e][f][f][u][n]			return TOKEN_KW_DEFFUN;
[f][o][r]					return TOKEN_KW_FOR;
[i][f]						return TOKEN_KW_IF;
[e][x][i][t]				return TOKEN_KW_EXIT;
[l][o][a][d]				return TOKEN_KW_LOAD;
[d][i][s][p]				return TOKEN_KW_DISP;
[t][r][u][e]				return TOKEN_KW_TRUE;
[f][a][l][s][e]				return TOKEN_KW_FALSE;

[+] 						return TOKEN_OP_PLUS;
[-] 						return TOKEN_OP_MINUS;
[/] 						return TOKEN_OP_DIV;
[*] 						return TOKEN_OP_MULT;
[(] 						return TOKEN_OP_OP;
[)] 						return TOKEN_OP_CP;
[*][*] 						return TOKEN_OP_DBLMULT;
["] 						{
								if(Qflag == 0){
									Qflag = 1;
									return TOKEN_OP_OC;
								} else {
									Qflag = 0;
									return TOKEN_OP_CC;
								}
							}
[,]							return TOKEN_OP_COMMA;

[;][;].* 					return TOKEN_COMMENT;
[0]|[1-9][0-9]*				return TOKEN_VALUE;		   
[a-zA-Z_][a-zA-Z0-9_]*		return TOKEN_IDENTIFIER;

[\n]|[\r\n]					return TOKEN_NEWLINE;
[ \t]+						return TOKEN_WHITESPACE;
.							return TOKEN_UNKNOWN;
%%

int yywrap(){ }

int main(int argc, char *argv[]){ 

    FILE *fpointer;
    int interpreterFlag = 0;
	if(argc == 1){
		interpreterFlag = 1;
	} else if(argc == 2){
	    fpointer = fopen(argv[1], "r");
		if(fpointer != NULL)
			yyin = fpointer;
		else{
			printf("Can not find the file specified!\n");
			return 0;
		}
	} else{
		printf("G++ can not get argument more than one.\n");
		return 0;
    }

    FILE *fp = fopen("parsed_cpp.txt", "w+");
    int temp_lex_code = 0, lex_code = TOKEN_NEWLINE, old_lex_code = TOKEN_NEWLINE;
    char temp_yylex[100];

	do
	{	
		if(interpreterFlag == 1 && lex_code == TOKEN_NEWLINE) printf("$g++> ");

		lex_code = yylex();

		if(old_lex_code == TOKEN_NEWLINE && lex_code == TOKEN_NEWLINE && yyin == stdin) yyterminate();
		old_lex_code = lex_code;

		if(lex_code > 0 && lex_code <= TOKEN_IDENTIFIER)
		{
			if((lex_code == TOKEN_VALUE || lex_code == TOKEN_IDENTIFIER))
			{
				strcpy(temp_yylex, yytext);
				temp_lex_code = yylex();
				if(temp_lex_code == TOKEN_VALUE || temp_lex_code == TOKEN_IDENTIFIER || temp_lex_code == TOKEN_UNKNOWN)
				{
					printf("SYNTAX ERROR %s%s can not be tokenized. ERROR\n", temp_yylex, yytext);
					fprintf(fp, "SYNTAX ERROR %s%s can not be tokenized. ERROR\n", temp_yylex, yytext);
				}
				else
				{
					printf("%s\n", tokensStrArr[lex_code]);
					fprintf(fp, "%s\n", tokensStrArr[lex_code]);
					lex_code = temp_lex_code;
					old_lex_code = lex_code;
					if(lex_code != TOKEN_NEWLINE && lex_code != TOKEN_WHITESPACE)
					{
						printf("%s\n", tokensStrArr[lex_code]);
						fprintf(fp, "%s\n", tokensStrArr[lex_code]);
					}
				}
			}
			else 
			{
				printf("%s\n", tokensStrArr[lex_code]);
				fprintf(fp, "%s\n", tokensStrArr[lex_code]);
			}
		}
		else if(lex_code != TOKEN_WHITESPACE && lex_code != TOKEN_NEWLINE && lex_code != 0)
		{
			printf("SYNTAX ERROR %s can not be tokenized. ERROR\n", yytext);
			fprintf(fp, "SYNTAX ERROR %s can not be tokenized. ERROR\n", yytext);
		}
	}while(lex_code != 0);

	if(fpointer == NULL)
		fclose(fpointer);
	fclose(fp);
	return 0;
}