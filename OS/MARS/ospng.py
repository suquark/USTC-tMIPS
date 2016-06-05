import sys
import png
lines=None
path=sys.argv[1]
with open(path) as f:
    lines=f.readlines()

parr=[]
for line in lines:
    pline=[]
    pline.append((255,255,255))
    for c in line:
        pline.append((0,0,0))
        if c=='0':
            for _ in range(0,10):
                pline.append((0,0,0))

        elif c=='1':
            for _ in range(0,10):
                pline.append((55,255,55))
    pline.append((255,255,255))
    for _ in range(0,10):
        parr.append(pline)
    
    parr.append([(0,0,0)]*len(pline))
    
(png.from_array(parr,'RGB')).save("a.png")
