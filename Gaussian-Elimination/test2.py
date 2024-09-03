from scipy import *

A = Matrix([
    [1, -2, 0, 7, 3, 0, 0, 4],
    [0, 0, 1, 3, -7, 0, 0, -1],
    [0, 0, 0, 0, 0, 1, 0, 4],
    [0, 0, 0, 0, 0, 0, 1, 3],
    [0, 0, 0, 0, 0, 0, 0, 0]
])

A[0,:] *= 3
A[1,:] += A[0,:]
A[2,:] += A[1,:]

A[0,:] += A[3,:]
A[1,:] -= 2 * A[3,:]
A[2,:] += 3 * A[3,:]
A[3,:] *= -1
A[4,:], A[2,:] = A[2,:], A[4,:]
A[2,:] += 4 * A[4,:]
A[0,:] -= 6 * A[2,:]
A[1,:] += A[2,:]
A[0,:] += 4 * A[1,:]

A[4,:] += A[3,:] + -3 * A[1,:]
A[3,:] += 2 * A[0,:] - 3 * A[1,:]
A[3,:] += A[4,:]
A[2,:] += 2 * A[1,:] - A[3,:]
A[4,:], A[3,:] = A[3,:], A[4,:]

def leftmost_nonzero(A, curr_row):
    for j in range(A.cols):
        for i in range(A.rows):
            if not A[i, j].is_zero:
                return (i + curr_row, j)
    return None

def fwd_elim(A):
    for i in range(A.rows):
        if A[i:,:].is_zero_matrix:
            return
        (j, k) = leftmost_nonzero(A[i:,:], i)
        A[i,:], A[j,:] = A[j,:], A[i,:]
        if i != j:
            print("=====")
            pprint(A)
            print()
            print("swap row " + str(i) + " and row " + str(j))
        for l in range(i + 1, A.rows):
            A[l,:] -= A[l, k] / A[i, k] * A[i,:]
            print("=====")
            pprint(A)
            print()
            print("zero out A[" + str(l) + "," + str(k) + "]")

def leading_entry_index(a):
    for i in range(len(a)):
        if a[i] != 0:
            return i

def back_sub(a):
    for curr_row in range(a.rows):
        curr_lead_ind = leading_entry_index(a[curr_row,:])
        if curr_lead_ind is not None:
            curr_lead = a[curr_row, curr_lead_ind]
            a[curr_row,:] /= curr_lead
            print("=====")
            pprint(a)
            print()
            print("normalize leading entry A[" + str(curr_row) + "," + str(curr_lead_ind) + "]")
            for i in range(curr_row):
                a[i,:] += (-1) * a[i, curr_lead_ind] * a.row(curr_row)
                print("=====")
                pprint(a)
                print()
                print("zero out A[" + str(i) + "," + str(curr_lead_ind) + "]")
        else:
            return

# pprint(A)
# fwd_elim(A)
# back_sub(A)

B = Matrix([
    [0, 3, -6, 6, 4, -5],
    [3, -9, 12, -9, 6, 15],
    [3, -7, 8, -5, 8, 9]
])

pprint(B)
fwd_elim(B)
back_sub(B)
