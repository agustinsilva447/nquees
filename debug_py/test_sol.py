import numpy as np    

n = int(input("Ingrese el tamano del tablero: "))
a = np.zeros([1, n+1])[0]
max_it = 41000
sol_list = 0
flag = 0
u_0 = 1
k = 0
k_aux = 1

with open('real_data_13.txt', 'w') as f:
    for iteration in range(max_it):
        while 1:
            a[k] = 0
            for u in np.arange(u_0, n + 1, 1):
                count = 0
                for j in range(k):
                    if ((u != a[j]) and (np.abs(u - a[j]) != (k - j))):
                        count += 1
                if count == k:
                    a[k] = u
                    break
            u_0 = 1
            if a[k] == 0:
                k -= 1
                k_aux -= 1
                if k_aux == 0:
                    flag = 1
                    break
                u_0 = a[k] + 1
                a[k] = 0
                k -= 1
                k_aux -= 1
            k += 1
            k_aux += 1
            if k == n:
                s1 = a[:n].astype(int).tolist()
                print(s1)
                s2 = ' '.join(map(str, s1)) + "\n\r"
                f.write(s2)
                sol_list += 1
                break    
        if flag:
            break

print("Final number of solutions: {}".format(sol_list))