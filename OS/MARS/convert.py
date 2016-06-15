import sys
lines=None
path=sys.argv[1]
with open(path) as f:
    lines=f.readlines()

with open(path,"w") as f:
    f.write("MEMORY_INITIALIZATION_RADIX=2;\n")
    f.write("MEMORY_INITIALIZATION_VECTOR=\n")
    for line in lines:
        line=line.strip()
        # if line.startswith("001001"):
        #    f.write("001000"+line[6:]+",\n")
        #elif line.endswith("100001") and line.startswith("0010"):
        #    f.write(line[:-6] + "100000,\n")
        #else:
        f.write(line + ",\n")
    f.write("0;\n")
