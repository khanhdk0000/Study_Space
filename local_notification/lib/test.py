def is_upper_triangle(a):
    for i in range(len(a)):
        if 0 in a[i][i:len(a)]:
            return False
        
        for ele in a[i][:i]:
            if ele != 0:
                return False
    return True

a = [[2, 1, 1],
     [0, -8, -2],
     [0, 0, 1]]
# print([ele == 0 for ele in [0, 0]])
print(is_upper_triangle(a))