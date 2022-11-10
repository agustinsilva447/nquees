app("connect")
app('set debug true')
app('x_write_reg 0 1')
app('x_write_reg 0 0')
app('x_write_fifo 1,2,3,4,5,6,7,8 8')

while(app(f'x_read_reg 0').data[1][0] == 0):
    pass
nsol = app(f'x_read_reg 1')
print(nsol.data[1][0])