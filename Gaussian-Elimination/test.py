from sympy import *

def leftmost_nonzero(A, curr_row):
    for j in range(A.cols):
        for i in range(A.rows):
            if not A[i, j].is_zero:
                return (i + curr_row, j)
    return None

def fwd_elim(A):
    for i in range(A.rows):
        if A[i:,:].is_zero_matrix:
            return A
        (j, k) = leftmost_nonzero(A[i:,:], i)
        A[i,:], A[j,:] = A[j,:], A[i,:]
        for l in range(i + 1, A.rows):
            A[l,:] -= A[l, k] / A[i, k] * A[i,:]
    return A

A = Matrix([
    [1, 1, 1],
    [2, 0, 3],
    [3, 1, -3]
])
fwd_elim(A)
pprint(A)
