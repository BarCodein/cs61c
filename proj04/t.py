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
c = nc.Matrix(9,1,[1,2,3,4,5,6,7,8,9])
print(c)
print(c[5:6])
d = a
print(d)
d = a[0:2]
print(d)