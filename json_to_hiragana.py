import sys
import json
import romkan

poems = json.loads(sys.stdin.read())
for poem in poems:
    for line in poem[u'Japanese'][u'Text']:
        print romkan.to_hiragana(filter(lambda char: char != ' ', line))
    print ''