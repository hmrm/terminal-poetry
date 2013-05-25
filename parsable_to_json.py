import sys
import json

lines = [line.decode('utf-8').strip() for line in sys.stdin.readlines()]

poems = []
curpoem = []

for line in lines:
    if line == '':
        if curpoem != []:
            poems.append(curpoem)
        curpoem = []
    else:
        curpoem.append(line)

poems.append(curpoem)

output = []
for poem in poems:
    info = { "Japanese" : {}, "English" : {}}
    length = len(poem) / 2
    info["Japanese"]["Author"] = poem[0]
    info["English"]["Author"] = poem[length]
    info["Japanese"]["Text"] = poem[1:length]
    info["English"]["Text"] = poem[length + 1:]
    output.append(info)
    
json.dump(output, sys.stdout, ensure_ascii = True)