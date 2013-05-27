import sys
peek = sys.argv[1]
host = sys.argv[2]
git = False
if(len(sys.argv) >= 4):
    git = True
    sha = int(sys.argv[3], 16)

with open("/home/hmrm/.oh-my-zsh/custom/poems.txt") as f:
   lines = f.readlines(4)

read = ''
try:
    with open("/home/hmrm/.oh-my-zsh/custom/.poem_line_tmp.tmp", "r") as tmp:
        read=tmp.read().strip()
except IOError:
    pass
        
if read == '':
    read = '0'

index = int(read)
if not peek == "true":
    with open("/home/hmrm/.oh-my-zsh/custom/.poem_line_tmp.tmp", "w") as tmp:
        tmp.write(str(index + 1))

print lines[index % len(lines)]