import re

CFG = { 
    'B1': {'stmts': ["a = 5", "b = 10"], 'succ': ['B2']}, 
    'B2': {'stmts': ["c = a + b"], 'succ': ['B3']}, 
    'B3': {'stmts': ["d = c + 2"], 'succ': ['B4']}, 
    'B4': {'stmts': ["e = d + 1"], 'succ': ['B5']}, 
    'B5': {'stmts': ["return c"], 'succ': []} 
}

def extract_variables(text):
    """
    Extracts variable names from a string.
    Matches alphabetic strings and ignores numbers and keywords like 'return'.
    """
    # Regex to find standard variable names (starts with letter/underscore)
    tokens = re.findall(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b', text)
    # Filter out language keywords
    return set(token for token in tokens if token not in ('return',))

# Dictionaries to store the resulting sets
USE = {}
DEF = {}

for block_name, block_data in CFG.items():
    block_def = set()
    block_use = set()
    
    for stmt in block_data['stmts']:
        stmt_def = set()
        stmt_use = set()
        
        # Check if it's an assignment statement
        if '=' in stmt:
            lhs, rhs = stmt.split('=', 1)
            stmt_def = extract_variables(lhs)
            stmt_use = extract_variables(rhs)
        else:
            # For statements without assignment (like "return c")
            stmt_use = extract_variables(stmt)
            
        # 1. Update block USE set
        # A variable is "used" in this block if it is read BEFORE it is defined in this block
        for u in stmt_use:
            if u not in block_def:
                block_use.add(u)
                
        # 2. Update block DEF set
        for d in stmt_def:
            block_def.add(d)
            
    USE[block_name] = block_use
    DEF[block_name] = block_def

# Print the results
print("--- USE and DEF Sets ---")
for block in CFG:
    # Formatting sets nicely (empty sets as '{}' instead of 'set()')
    def_str = '{' + ', '.join(sorted(DEF[block])) + '}' if DEF[block] else '{}'
    use_str = '{' + ', '.join(sorted(USE[block])) + '}' if USE[block] else '{}'
    
    print(f"{block}:")
    print(f"  DEF = {def_str}")
    print(f"  USE = {use_str}")