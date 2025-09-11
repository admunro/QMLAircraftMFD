#!/usr/bin/env python3

import json

structures = {}

class structure:

    structure_names = []

    def __init__(self, name, type, initial_value = None):

        if self.name in structure.structure_names:
            raise Exception(f'Structure with name {name} already exists!')

        structure.structure_names.append(name)

        self.name = name
        self.type = type
        self.initial_value = initial_value

    




def infer_cpp_type(value):

    if isinstance(value, int):
        return 'int'
    elif isinstance(value, str):
        return 'string'
    elif isinstance(value, float):
        return 'double'
    
    return None


def parse_json(parent_name, data):

    this_struct = {}

    for key, value in data.items():
        if isinstance(value, dict):
            parse_json(key, value)
            this_struct[key] = structures[key]
        else:
            this_struct[key] = (infer_cpp_type(value), key, value)

    structures[parent_name] = this_struct



 


if __name__ == "__main__":
    
    file = open('entity.json', 'r')
    data = json.load(file)
    file.close()


    parse_json('entity', data)

    print(structures['entity'])
    
    pass
