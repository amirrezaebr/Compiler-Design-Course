def comment_remover(input_comment: str,i:int,j:int):
    input_comment = input_comment[:i] + input_comment[j + 2:]
    return input_comment


def comment_finder(input_comment: str):
    last_index = len(input_comment) - 1

    for i in range(len(input_comment)):
        if input_comment[i:i + 2] == "/*":
            for j in range(last_index, i, -1):
                if input_comment[j:j + 2] == "*/":
                    input_comment = comment_remover(input_comment, i, j)
                    last_index = j - 1
                    break
    return input_comment


test1 = """
outside
/*/*/*
inside
*/
*/
*/
"""

test2 = "aaa/*bbb*/aaa"
test3 = "code /* comment /* nested */ still comment */ final"
test4 = "code /* start /* nested1 /* nested2 */ end1 */ end2 */ final"

print("test 1: " + test1)
print("output: " + comment_finder(test1))
print("test 2: " + test2)
print("output: " + comment_finder(test2))
print("test 3: " + test3)
print("output: " + comment_finder(test3))
print("test 4: " + test4)
print("output: " + comment_finder(test4))

