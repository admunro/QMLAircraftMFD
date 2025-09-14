#!/usr/bin/env python3

import json

class Data_type:

    def __init__(self, data_type, name, initial_value = None):
        self.data_type = data_type
        self.name = name
        self.initial_value = initial_value
        
    def __repr__(self):
        return f"Data_type ({self.data_type} {self.name} = {self.initial_value})"
  

class Structure:

    structures = []

    def get_structure(type):

        for struct in Structure.structures:
            if struct.type == type:
                return struct
            
        return None

    def __init__(self, type, name):

        if Structure.get_structure(type) is not None:    
            raise Exception(f'Structure with type {type} already exists!')

        self.name = name
        self.type = type
            
        self.members = []

        Structure.structures.append(self)

    def __repr__(self):
        return f"Structure ({self.type} {self.name})"

    def add_struct(self, struct):
        self.members.append(struct)

    def add_member(self, new_member):
        
        for member in self.members:
            if member.name == new_member.name:
                raise Exception(f'Member with name {new_member.name} already exists!')
            
        self.members.append(new_member)


def infer_cpp_type(value):

    if isinstance(value, int):
        return 'int'
    elif isinstance(value, str):
        return 'string'
    elif isinstance(value, float):
        return 'double'
    
    return None


def parse_json(containing_struct, data):

    for key, value in data.items():

        if isinstance(value, dict):    
            this_struct = Structure(key.lower().capitalize(), key.lower())
            parse_json(this_struct, value)
            containing_struct.add_struct(this_struct)
        else:
            containing_struct.add_member(Data_type(infer_cpp_type(value), key, value))



if __name__ == "__main__":
    
    file = open('entity.json', 'r')
    data = json.load(file)
    file.close()

    top_level_structure = Structure(type='Entity', name='entity')

    parse_json(top_level_structure, data)

    pass