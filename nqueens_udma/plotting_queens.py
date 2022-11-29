import numpy as np
import matplotlib.pyplot as plt

n = np.arange(5,18)
t = np.array([0.061923,
              0.064429,
              0.065487,
              0.066274,
              0.069968,
              0.070077,
              0.120131,
              0.174211,
              0.798081,
              4.380318,
              32.22904,
              219.42070,
              1808.462])
s = np.array([10,
              4,
              40,
              92,
              352,
              724,
              2680,
              14200,
              73712,
              365596,
              2279184,
              14772512,
              95815104])              

print(np.exp(28)/(3600*24*365))
#plt.plot(np.log(s),np.log(t),'*')
plt.plot(n,np.log(t),'*')
plt.show()