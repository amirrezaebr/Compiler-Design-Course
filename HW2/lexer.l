%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "types.h"
#include "parser.tab.h"

int line_num = 1;
%}

%option nounput
%option noinput

%%
[ \t]+          { /* ignore whitespace */ }
[\n]            { line_num++; }

"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"/"             { return DIVIDE; }

"=="            { return EQ; }
"!="            { return NEQ; }
"<"             { return LT; }
"<="            { return LE; }
">"             { return GT; }
">="            { return GE; }

"&&"            { return AND; }
"||"            { return OR; }
"!"             { return NOT; }

"("             { return LPAREN; }
")"             { return RPAREN; }

"true"          { yylval.bval = 1; return BOOL; }
"false"         { yylval.bval = 0; return BOOL; }

[0-9]+          { yylval.ival = atoi(yytext); return INT; }

"int"           { return TYPE_INT; }
"bool"          { return TYPE_BOOL; }

[a-zA-Z][a-zA-Z0-9_]*  { 
                    yylval.sval = strdup(yytext); 
                    return ID; 
                }

.               { printf("Unrecognized character %c at line %d\n", yytext[0], line_num); }

%%

int yywrap() {
    return 1;
}
