#!/usr/bin/env python
import json
from pprint import pprint
import sys
file = sys.argv[1]
print(file)
json_data=open(file).read()
data = json.loads(json_data)
for a in data['addresses']:
    pubkeyArray=data['addresses'][a]['publicKey']['data']
    pubkey=""
    for pbk in pubkeyArray:
        pubkey = "%s%02x" % (pubkey,pbk)
    print (f"Address:{a}")
    print (f"Public Key: {pubkey}" )
    print (f"Private Key: {data['private_keys'][a]}")