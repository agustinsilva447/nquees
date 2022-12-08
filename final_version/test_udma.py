#app("connect")
#app('log 0')
app('x_write_reg 0 1')
app('x_write_reg 0 0')
a = app(f'x_read_reg 0').data[1]
b = app(f'x_read_reg 1').data[1]
c = app(f'x_read_reg 2 -r h').data[1]
print(a,b,c)