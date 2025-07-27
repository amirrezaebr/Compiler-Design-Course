def tokenize_python_code(code):
    keywords = ['and', 'as', 'assert', 'break', 'class', 'def', 'del',
                'elif', 'else', 'except', 'exec', 'finally', 'for', 'from', 'global', 'if', 'import',
                'in', 'is', 'lambda', 'not', 'or', 'pass', 'print', 'raise', 'return', 'try', 'while', 'with', 'yield']
    operators = {"+", "-", "*", "/", "=", "<", ">", "<=", ">=", "==", "!=", "%"}
    separators = {"(", ")", "{", "}", "[", "]", ",", ":", ";"}
    tokens = []

    line_num = 1
    column = 0
    i = 0

    while i < len(code):
        char = code[i]
        column += 1

        if char.isspace():
            if char == '\n':
                line_num += 1
                column = 0
            i += 1
            continue

        if char in separators:
            tokens.append(("SEPARATOR", char, line_num, column))
            i += 1
            continue

        if char in operators:
            op = char
            if i + 1 < len(code) and code[i + 1] in operators:
                op += code[i + 1]
                i += 1
            tokens.append(("OPERATOR", op, line_num, column))
            i += 1
            continue

        if char.isdigit():
            num = char
            while i + 1 < len(code) and code[i + 1].isdigit():
                num += code[i + 1]
                i += 1
            tokens.append(("NUMBER", num, line_num, column))
            i += 1
            continue

        if char.isalpha() or char == "_":
            identifier = char
            while i + 1 < len(code) and (code[i + 1].isalnum() or code[i + 1] == "_"):
                identifier += code[i + 1]
                i += 1
            token_type = "KEYWORD" if identifier in keywords else "IDENTIFIER"
            tokens.append((token_type, identifier, line_num, column))
            i += 1
            continue

        raise RuntimeError(f'Unexpected token {char} at line {line_num}, column {column}')

    return tokens


# Example usage
code_sample = """
def foo(x):
    if x > 10:
        return x + 1
"""

for token in tokenize_python_code(code_sample):
    print(token)
