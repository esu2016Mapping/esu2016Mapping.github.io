import re

newData = []

with open("raw.csv", "r", encoding="utf8") as f1:
    data = f1.read().split("\n")

    header = (data[0]+"\tType\tRegion").split("\t")
    del header[2]
    newData.append("\t".join(header))

    for l in data[1:]:
        l = l.split("\t")
        try:
            typ = re.search(r"Deposit type</th><td>(.*?)</td>", l[2]).group(1)
            reg = re.search(r"Country</th><td>(.*?)</td>", l[2]).group(1)
            l.append(typ)
            l.append(reg)
            del l[2]
            newData.append("\t".join(l))
    
        except:
            print(l)


with open("reformatted.csv", "w", encoding="utf8") as f9:
    f9.write("\n".join(newData))
    
