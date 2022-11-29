import time

app("connect")
app('log 0')
app('x_write_reg 0 1')
app('x_write_reg 0 0')

start = time.time()
app('x_write_fifo 1,2,3,4,5,6,7,8,9 9')
while(app(f'x_read_reg 0').data[1][0] == 0):
    time.sleep(60)
    print(app(f'x_read_reg 1'))
    pass
end = time.time()
nsol = app(f'x_read_reg 1')

print("Solutions:", nsol.data[1][0])
print("Time:", end - start)