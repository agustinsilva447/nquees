import numpy as np

def presols_list(n,m):
    presols = []
    aux = []
    for i in range(int(np.ceil(n/2))):
        aux.append([i+1])
    presols.append(aux)
    for i in range(m-1):
        presols.append([])
        for j in presols[i]:
            for l in np.arange(1,n+1,1):
                counter = 0
                for h,k in enumerate(j):            
                    if ((k != l) and (np.abs(k - l) != (i+1-h))):
                        counter += 1
                    else:
                        break
                if counter == (i+1):
                    aux = j[:]
                    aux.append(l)
                    presols[i+1].append(aux)
    return presols

def int_to_binary(n,m):
    if n == 0:
        return "0"
    binary1 = ""
    while n > 0:
        binary1 = str(n % 2) + binary1
        n = n // 2
    binary2 = "0" * (m - len(binary1)) + binary1
    return binary2

n = 10
m = 10
presols_i = presols_list(n,m)[m-1]

presols_o = []
for i in presols_i:
    presol = ""
    for j in i:
        presol += int_to_binary(j,8)
    presols_o.append(int(presol,2))
    

data = ','.join(map(str, presols_o))
lenght = len(presols_o)
print("N = {}. M = {}.".format(n,m))
print('Number of pre-solutions: {}.'.format(lenght))
#print('Pre-solutions: {}.'.format(data))