%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "types.h"

extern int yylex();
extern int line_num;
void yyerror(const char *s);

// Function prototypes for type checking
Type check_arithmetic(Type t1, Type t2);
Type check_comparison(Type t1, Type t2);
Type check_logical(Type t1, Type t2);
void check_type_error(Type expected, Type actual, const char *op);
%}

%union {
    int ival;
    int bval;
    char *sval;
    ExprValue expr;
}

%token <ival> INT
%token <bval> BOOL
%token <sval> ID
%token PLUS MINUS TIMES DIVIDE
%token EQ NEQ LT LE GT GE
%token AND OR NOT
%token TYPE_INT TYPE_BOOL
%token LPAREN RPAREN

%type <expr> expr arithmetic_expr comparison_expr logical_expr primary

%left OR
%left AND
%left EQ NEQ
%left LT LE GT GE
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT
%left LPAREN RPAREN

%%

program: expr { 
    printf("Evaluation result: ");
    if ($1.type == INT_TYPE) {
        printf("%d (Integer)\n", $1.value);
    } else if ($1.type == BOOL_TYPE) {
        printf("%s (Boolean)\n", $1.value ? "true" : "false");
    } else {
        printf("Type Error\n");
    }
}
;

expr: arithmetic_expr { $$ = $1; }     | comparison_expr { $$ = $1; }
    | logical_expr    { $$ = $1; }     | primary         { $$ = $1; }
;

primary: INT             { $$.value = $1; $$.type = INT_TYPE; }
       | BOOL            { $$.value = $1; $$.type = BOOL_TYPE; }
       | LPAREN expr RPAREN { $$ = $2; } ;  arithmetic_expr: expr PLUS expr  {                      $$.type = check_arithmetic($1.type, $3.type);
                    if ($$.type != TYPE_ERROR) {                         $$.value = $1.value + $3.value;
                    }
                }
                | expr MINUS expr { 
                    $$.type = check_arithmetic($1.type, $3.type);                     if ($$.type != TYPE_ERROR) {
                        $$.value = $1.value - $3.value;                     }                 }                 | expr TIMES expr {                      $$.type = check_arithmetic($1.type, $3.type);
                    if ($$.type != TYPE_ERROR) {                         $$.value = $1.value * $3.value;
                    }
                }
                | expr DIVIDE expr { 
                    $$.type = check_arithmetic($1.type, $3.type);                     if ($$.type != TYPE_ERROR) {
                        if ($3.value == 0) {
                            printf("Error: Division by zero\n");
                            $$.type = TYPE_ERROR;                         } else {                             $$.value = $1.value / $3.value;
                        }
                    }
                }
;

comparison_expr: expr EQ expr { 
                    $$.type = check_comparison($1.type, $3.type);                     if ($$.type != TYPE_ERROR) {
                        $$.value = ($1.value == $3.value) ? 1 : 0;                     }                 }                 | expr NEQ expr {                      $$.type = check_comparison($1.type, $3.type);
                    if ($$.type != TYPE_ERROR) {                         $$.value = ($1.value != $3.value) ? 1 : 0;
                    }
                }
                | expr LT expr { 
                    $$.type = check_comparison($1.type, $3.type);                     if ($$.type != TYPE_ERROR) {
                        $$.value = ($1.value < $3.value) ? 1 : 0;                     }                 }                 | expr LE expr {                      $$.type = check_comparison($1.type, $3.type);
                    if ($$.type != TYPE_ERROR) {                         $$.value = ($1.value <= $3.value) ? 1 : 0;
                    }
                }
                | expr GT expr { 
                    $$.type = check_comparison($1.type, $3.type);                     if ($$.type != TYPE_ERROR) {
                        $$.value = ($1.value > $3.value) ? 1 : 0;                     }                 }                 | expr GE expr {                      $$.type = check_comparison($1.type, $3.type);
                    if ($$.type != TYPE_ERROR) {                         $$.value = ($1.value >= $3.value) ? 1 : 0;
                    }
                }
;

logical_expr: expr AND expr { 
                $$.type = check_logical($1.type, $3.type);                 if ($$.type != TYPE_ERROR) {
                    if ($1.value == 0) {
                        $$.value = 0;                         printf("Short-circuit: AND operation stopped at false\n");                     } else {                         $$.value = ($3.value != 0) ? 1 : 0;
                    }
                }
            }
            | expr OR expr { 
                $$.type = check_logical($1.type, $3.type);                 if ($$.type != TYPE_ERROR) {
                    if ($1.value != 0) {
                        $$.value = 1;                         printf("Short-circuit: OR operation stopped at true\n");                     } else {                         $$.value = ($3.value != 0) ? 1 : 0;
                    }
                }
            }
            | NOT expr { 
                if ($2.type != BOOL_TYPE) {
                    printf("Type Error: NOT operator expects Boolean\n");
                    $$.type = TYPE_ERROR;                 } else {                     $$.type = BOOL_TYPE;
                    $$.value = ($2.value == 0) ? 1 : 0;
                }
            }
;

%%

Type check_arithmetic(Type t1, Type t2) {
    if (t1 == INT_TYPE && t2 == INT_TYPE) {
        return INT_TYPE;
    } else {
        printf("Type Error: Arithmetic operations require Integer operands\n");
        return TYPE_ERROR;
    }
}

Type check_comparison(Type t1, Type t2) {
    if (t1 == t2 && (t1 == INT_TYPE || t1 == BOOL_TYPE)) {
        return BOOL_TYPE;
    } else {
        printf("Type Error: Comparison operations require operands of the same type\n");
        return TYPE_ERROR;
    }
}

Type check_logical(Type t1, Type t2) {
    if (t1 == BOOL_TYPE && t2 == BOOL_TYPE) {
        return BOOL_TYPE;
    } else {
        printf("Type Error: Logical operations require Boolean operands\n");
        return TYPE_ERROR;
    }
}

void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d: %s\n", line_num, s);
}

int main() {
    printf("Enter an expression to evaluate (Ctrl+D to exit):\n");

    
    yyparse();
    return 0;
}
