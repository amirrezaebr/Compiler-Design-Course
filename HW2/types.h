#ifndef TYPES_H
#define TYPES_H

// Define types for our type checker
typedef enum {
    TYPE_ERROR,
    INT_TYPE,
    BOOL_TYPE
} Type;

// Structure for expressions with type information
typedef struct {
    int value;
    Type type;
} ExprValue;

#endif
