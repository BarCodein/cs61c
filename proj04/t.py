import numc as nc
a = nc.Matrix(3,3,[1,2,3,4,5,6,7,8,9])
print(a)
print(a[1,1])
print(a[1])
print(a[0:1][0:1])
print(a[0:1,0:1])
print(a[:][:])
b = nc.Matrix(1,9,[1,2,3,4,5,6,7,8,9])
print(b)
print(b[:3])
b[2] = 1
b[2:3] = 1
b[2:5] = [2,3,4]
print(b)
c = nc.Matrix(9,1,[1,2,3,4,5,6,7,8,9])
print(c)
print(c[5:6])
print(c[7:9])
c[1] = 1
c[1:2] = 1
print(c)
d = a
print(d)
print(a[0,0])
a[0,0] = 3
print(d)
print(a)