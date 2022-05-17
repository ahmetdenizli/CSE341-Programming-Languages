%{
    /* definitions */

    // includes..
    #include<stdio.h>

    #include<math.h>

    // Extern..
    extern int yylex();
    extern int yyparse();
    extern FILE * yyin;

    int ArrayForList[9999];
    int lstIndxCounter = 0;
    int secondListIndx = 0;

    int isExitFlag = 0;
    int isListFlag = 0;
    int isBinaryFlag = 0;

    FILE * fp_gpp; 
%}

%token TOKEN_KW_AND TOKEN_KW_OR TOKEN_KW_NOT TOKEN_KW_EQUAL TOKEN_KW_LESS TOKEN_KW_NIL TOKEN_KW_LIST TOKEN_KW_APPEND TOKEN_KW_CONCAT TOKEN_KW_SET TOKEN_KW_DEFFUN TOKEN_KW_DEFVAR TOKEN_KW_FOR TOKEN_KW_IF TOKEN_KW_EXIT TOKEN_KW_LOAD TOKEN_KW_DISP TOKEN_KW_TRUE TOKEN_KW_FALSE

%token TOKEN_OP_PLUS TOKEN_OP_MINUS TOKEN_OP_DIV TOKEN_OP_MULT TOKEN_OP_OP TOKEN_OP_CP TOKEN_OP_DBLMULT TOKEN_OP_OC TOKEN_OP_CC TOKEN_OP_COMMA

%token TOKEN_INTEGER_VALUE TOKEN_COMMENT TOKEN_IDENTIFIER TOKEN_LISTOP TOKEN_FLE

%start START

%%
/* rules */

START: | INPUT {
    if (isExitFlag != 1) {
        printf("Syntax OK.\n");
        fprintf(fp_gpp, "Syntax OK.\n");
        if (isListFlag) {
            int i;
            printf("Result: (");
            fprintf(fp_gpp, "Result: (");

            for (i = 0; i < lstIndxCounter; ++i) {
                if (i != lstIndxCounter - 1) {
                    printf("%d ", ArrayForList[i]);
                    fprintf(fp_gpp, "%d ", ArrayForList[i]);
                } else {
                    printf("%d", ArrayForList[i]);
                    fprintf(fp_gpp, "%d", ArrayForList[i]);
                }
            }
            printf(")\n");
            fprintf(fp_gpp, ")\n");

            lstIndxCounter = 0;
            secondListIndx = 0;
            isListFlag = 0;
        } else if (isBinaryFlag) {
            isBinaryFlag = 0;
            if ($$ != 1) {
                printf("Result: NIL\n");
                fprintf(fp_gpp, "Result: NIL\n");
            } else {
                printf("Result: T\n");
                fprintf(fp_gpp, "Result: T\n");
            }
        } else {
            printf("Result: %d\n", $$);
            fprintf(fp_gpp, "Result: %d\n", $$);
        }
    }
    return 0;
};

INPUT: EXPI | EXPLISTI | EXPB {
    isBinaryFlag = 1;
};

EXPLISTI: TOKEN_OP_OP TOKEN_KW_CONCAT EXPLISTI EXPLISTI TOKEN_OP_CP {
        isListFlag = 1;
        $$ = 1;
    } |
    TOKEN_OP_OP TOKEN_KW_APPEND EXPI EXPLISTI TOKEN_OP_CP {
        $$ = 1;

        int i;
        for (i = lstIndxCounter - 1; i > -1; --i)
            ArrayForList[i + 1] = ArrayForList[i];
        ArrayForList[0] = $3;

        ++lstIndxCounter;
        isListFlag = 1;
    } |
    LISTVALUE {
        $$ = 1;
    };

EXPI: TOKEN_OP_OP TOKEN_KW_DEFVAR TOKEN_IDENTIFIER EXPI TOKEN_OP_CP {
        $$ = $4;
    } |
    TOKEN_OP_OP TOKEN_KW_SET TOKEN_IDENTIFIER EXPI TOKEN_OP_CP {
        $$ = $4;
    } |
    TOKEN_OP_OP TOKEN_OP_PLUS EXPI EXPI TOKEN_OP_CP {
        $$ = $3 + $4;
    } |
    TOKEN_OP_OP TOKEN_OP_MINUS EXPI EXPI TOKEN_OP_CP {
        $$ = $3 - $4;
    } |
    TOKEN_OP_OP TOKEN_OP_DIV EXPI EXPI TOKEN_OP_CP {
        $$ = $3 / $4;
    } |
    TOKEN_OP_OP TOKEN_OP_MULT EXPI EXPI TOKEN_OP_CP {
        $$ = $3 * $4;
    } |
    TOKEN_OP_OP TOKEN_OP_DBLMULT EXPI EXPI TOKEN_OP_CP {
        $$ = pow($3, $4);
    } |
    TOKEN_OP_OP TOKEN_IDENTIFIER EXPLISTI TOKEN_OP_CP {
        $$ = $3;
        isListFlag = 1;
    } |
    TOKEN_OP_OP TOKEN_KW_LIST VALUES TOKEN_OP_CP {
        $$ = 1;
        isListFlag = 1;
    } |
    TOKEN_OP_OP TOKEN_KW_DEFFUN TOKEN_IDENTIFIER IDLIST EXPLISTI TOKEN_OP_CP {
        $$ = $5;
        isListFlag = 1;
    } |
    TOKEN_OP_OP TOKEN_KW_FOR TOKEN_OP_OP TOKEN_IDENTIFIER EXPI EXPI TOKEN_OP_CP EXPLISTI TOKEN_OP_CP {
        isListFlag = 1;
    } |
    TOKEN_OP_OP TOKEN_KW_IF EXPB EXPLISTI TOKEN_OP_CP {
        $$ = $3;
        if ($3 != 1) {
            lstIndxCounter = 0;
            ArrayForList[0] = NULL;
        }
        isListFlag = 1;
    } |
    TOKEN_OP_OP TOKEN_KW_IF EXPB EXPLISTI EXPLISTI TOKEN_OP_CP {
        $$ = $3;
        if (!$3) {
            lstIndxCounter = lstIndxCounter - secondListIndx;
            int i;
            for (i = 0; i < lstIndxCounter; ++i) {
                ArrayForList[i] = ArrayForList[secondListIndx + i];
            }
        } else {
            lstIndxCounter = secondListIndx;
        }
        isListFlag = 1;
    } |
    TOKEN_OP_OP TOKEN_KW_EXIT TOKEN_OP_CP {
        isExitFlag = 1;
        printf("Bye.\n");
        fprintf(fp_gpp, "Bye.\n");
        return 0;
    } |
    TOKEN_OP_OP TOKEN_KW_LOAD TOKEN_OP_OC TOKEN_FLE TOKEN_OP_CC TOKEN_OP_CP {
        $$ = 1;
    } |
    TOKEN_OP_OP TOKEN_KW_DISP EXPI TOKEN_OP_CP {
        $$ = 1;
    } |
    TOKEN_IDENTIFIER {
        $$ = 1;
    } |
    TOKEN_INTEGER_VALUE {
        $$ = $1;
    } |
    TOKEN_COMMENT {
        printf("COMMENT\n");
        fprintf(fp_gpp, "COMMENT\n");
        return 0;
    };

EXPB: BinaryValue {
        $$ = $1;
    } |
    TOKEN_OP_OP TOKEN_KW_AND EXPB EXPB TOKEN_OP_CP {
        $$ = $3 && $4;
    } |
    TOKEN_OP_OP TOKEN_KW_OR EXPB EXPB TOKEN_OP_CP {
        $$ = $3 || $4;
    } |
    TOKEN_OP_OP TOKEN_KW_NOT EXPB TOKEN_OP_CP {
        $$ = !$3;
    } |
    TOKEN_OP_OP TOKEN_KW_EQUAL EXPB EXPB TOKEN_OP_CP {
        $$ = ($3 == $4);
    } |
    TOKEN_OP_OP TOKEN_KW_EQUAL EXPI EXPI TOKEN_OP_CP {
        $$ = ($3 == $4);
    } |
    TOKEN_OP_OP TOKEN_KW_LESS EXPI EXPI TOKEN_OP_CP {
        $$ = ($3 < $4);
    };

IDLIST: TOKEN_OP_OP IDNTLIST TOKEN_OP_CP;

IDNTLIST: IDNTLIST TOKEN_IDENTIFIER | TOKEN_IDENTIFIER;

BinaryValue: TOKEN_KW_TRUE {
        $$ = 1;
    } |
    TOKEN_KW_FALSE {
        $$ = 0;
    };

LISTVALUE: TOKEN_LISTOP VALUES TOKEN_OP_CP {
        isListFlag = 1;
        if (secondListIndx == 0)
            secondListIndx = lstIndxCounter;
    } |
    TOKEN_LISTOP TOKEN_OP_CP {
        $$ = 0;
        isListFlag = 1;
        lstIndxCounter = 0;
    } |
    TOKEN_KW_NIL {
        $$ = 0;
    };

VALUES: VALUES TOKEN_INTEGER_VALUE {
        ArrayForList[lstIndxCounter] = $2;
        ++lstIndxCounter;
    } |
    TOKEN_INTEGER_VALUE {
        ArrayForList[lstIndxCounter] = $1;
        ++lstIndxCounter;
    } |
    TOKEN_KW_NIL {
        $$ = 0;
    };

%%

int yywrap() {
    return 1;
}

int yyerror(const char * ch) {
    isExitFlag = 1;
    printf("SYNTAX_ERROR Expression not recognized\n");
    fprintf(fp_gpp, "SYNTAX_ERROR Expression not recognized\n");
}

int main(int argc, char * argv[]) {
    FILE * fpointer;

    if (argc == 1) {
        fp_gpp = fopen("parsed_gpp.txt", "w");
        yyin = stdin;
        while (isExitFlag != 1) {
            yyparse();
        }
    } else if (argc == 2) {
        fp_gpp = fopen("parsed_gpp.txt", "w");
        fpointer = fopen(argv[1], "r");
        if (fpointer != NULL) {
            yyin = fpointer;
            while (isExitFlag != 1)
                yyparse();
        } else {
            printf("Can not find the file specified!\n");
            return -1;
        }
    } else {
        printf("G++ can not get argument more than one.\n");
        printf("Terminal interpreter: Run program without argument.\n");
        printf("File interpreter: Run program with filename argument.\n");
    }

    return 0;
}