/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TOKEN_KW_AND = 258,
    TOKEN_KW_OR = 259,
    TOKEN_KW_NOT = 260,
    TOKEN_KW_EQUAL = 261,
    TOKEN_KW_LESS = 262,
    TOKEN_KW_NIL = 263,
    TOKEN_KW_LIST = 264,
    TOKEN_KW_APPEND = 265,
    TOKEN_KW_CONCAT = 266,
    TOKEN_KW_SET = 267,
    TOKEN_KW_DEFFUN = 268,
    TOKEN_KW_DEFVAR = 269,
    TOKEN_KW_FOR = 270,
    TOKEN_KW_IF = 271,
    TOKEN_KW_EXIT = 272,
    TOKEN_KW_LOAD = 273,
    TOKEN_KW_DISP = 274,
    TOKEN_KW_TRUE = 275,
    TOKEN_KW_FALSE = 276,
    TOKEN_OP_PLUS = 277,
    TOKEN_OP_MINUS = 278,
    TOKEN_OP_DIV = 279,
    TOKEN_OP_MULT = 280,
    TOKEN_OP_OP = 281,
    TOKEN_OP_CP = 282,
    TOKEN_OP_DBLMULT = 283,
    TOKEN_OP_OC = 284,
    TOKEN_OP_CC = 285,
    TOKEN_OP_COMMA = 286,
    TOKEN_INTEGER_VALUE = 287,
    TOKEN_COMMENT = 288,
    TOKEN_IDENTIFIER = 289,
    TOKEN_LISTOP = 290,
    TOKEN_FLE = 291
  };
#endif
/* Tokens.  */
#define TOKEN_KW_AND 258
#define TOKEN_KW_OR 259
#define TOKEN_KW_NOT 260
#define TOKEN_KW_EQUAL 261
#define TOKEN_KW_LESS 262
#define TOKEN_KW_NIL 263
#define TOKEN_KW_LIST 264
#define TOKEN_KW_APPEND 265
#define TOKEN_KW_CONCAT 266
#define TOKEN_KW_SET 267
#define TOKEN_KW_DEFFUN 268
#define TOKEN_KW_DEFVAR 269
#define TOKEN_KW_FOR 270
#define TOKEN_KW_IF 271
#define TOKEN_KW_EXIT 272
#define TOKEN_KW_LOAD 273
#define TOKEN_KW_DISP 274
#define TOKEN_KW_TRUE 275
#define TOKEN_KW_FALSE 276
#define TOKEN_OP_PLUS 277
#define TOKEN_OP_MINUS 278
#define TOKEN_OP_DIV 279
#define TOKEN_OP_MULT 280
#define TOKEN_OP_OP 281
#define TOKEN_OP_CP 282
#define TOKEN_OP_DBLMULT 283
#define TOKEN_OP_OC 284
#define TOKEN_OP_CC 285
#define TOKEN_OP_COMMA 286
#define TOKEN_INTEGER_VALUE 287
#define TOKEN_COMMENT 288
#define TOKEN_IDENTIFIER 289
#define TOKEN_LISTOP 290
#define TOKEN_FLE 291

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
