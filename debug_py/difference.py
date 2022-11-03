import pandas as pd

df1 = pd.read_csv("fpga_data_new.txt", header=None)
df2 = pd.read_csv("real_data_13.txt", header=None)

for a,b in zip(df1.iterrows(), df2.iterrows()):
    if (a[1] != b[1]).any():
        print(a[0], b[0])
        break