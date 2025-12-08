import json
with open('generated.json', 'r') as file:
    json_object = json.load(file)
    

# goal:
# change obj[key1][n][key2][n][key3] from "treasurevalue<n>" -> "foundvalue<n>"
# constraints: key<j> can be a list or a singleton
# print(json_object["key1"][0]['key2'][0]['key3'])

path = ["key1", "key2", "key3"]
finalkey = path[-1]
def mutator(index, parent_object):
    json_key = path[index]
    subobject = parent_object[json_key]

    if index >= len(path):
        raise RuntimeError("invalid path")
    if json_key == finalkey:
        # print the desired value
        parent_object[json_key] = "redacted"
        return
    
    if isinstance(subobject, list):
        for k in range(0, len(subobject)):
            mutator(index + 1, subobject[k])
    else:
        mutator(index + 1, subobject)

mutator(0, json_object)

print(json.dumps(json_object, indent=4))