import pandas as pd

df = pd.read_csv("debug_data_new.txt", sep=' ')
aux0 = 0
aux1 = 0
aux2 = 0
aux3 = 0

with open('fpga_data_new.txt', 'w') as f:
    for i, j in df.iterrows():
        if (aux3 != j["Counter"]):
            out_2 = bin(int(aux2))[2:].zfill(1)
            out_1 = bin(int(aux1))[2:].zfill(32)
            out_0 = bin(int(aux0))[2:].zfill(32)
            tot = out_2 + out_1 + out_0
            sol = []
            for k in range(13):
                s = tot[5*k:5*(k+1)]
                sol.append(int(s,2))  
            print(sol)
            s2 = ' '.join(map(str, sol)) + "\n\r"
            f.write(s2)            
            aux3 = j["Counter"]
        aux2 = j["a_out_2"]
        aux1 = j["a_out_1"]
        aux0 = j["a_out_0"]