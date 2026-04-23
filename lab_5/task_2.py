import re

# Given Control Flow Graph
CFG = { 
    'B1': {'stmts': ["a = 5", "b = 10"], 'succ': ['B2']}, 
    'B2': {'stmts': ["c = a + b"], 'succ': ['B3']}, 
    'B3': {'stmts': ["d = c + 2"], 'succ': ['B4']}, 
    'B4': {'stmts': ["e = d + 1"], 'succ': ['B5']}, 
    'B5': {'stmts': ["return c"], 'succ': []} 
}

def extract_variables(text):
    """Extracts valid variable names from a statement."""
    tokens = re.findall(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b', text)
    return set(token for token in tokens if token not in ('return',))

# --- STEP 1: Compute USE and DEF Sets ---
USE = {}
DEF = {}

for block, data in CFG.items():
    block_def = set()
    block_use = set()
    
    for stmt in data['stmts']:
        stmt_def = set()
        stmt_use = set()
        
        if '=' in stmt:
            lhs, rhs = stmt.split('=', 1)
            stmt_def = extract_variables(lhs)
            stmt_use = extract_variables(rhs)
        else:
            stmt_use = extract_variables(stmt)
            
        for u in stmt_use:
            if u not in block_def:
                block_use.add(u)
                
        for d in stmt_def:
            block_def.add(d)
            
    USE[block] = block_use
    DEF[block] = block_def

# --- STEP 2: Compute IN and OUT Sets (Live Variable Analysis) ---

# Initialize IN and OUT sets to empty for all blocks
IN = {block: set() for block in CFG}
OUT = {block: set() for block in CFG}

# We iterate until no IN sets change (Fixed-Point Iteration)
changed = True
while changed:
    changed = False
    
    # Process backwards for efficiency (since it's a backward analysis)
    for block in reversed(list(CFG.keys())):
        
        # Calculate OUT[B] = Union of IN[S] for all successors S
        new_out = set()
        for succ in CFG[block]['succ']:
            new_out = new_out.union(IN[succ])
        OUT[block] = new_out
        
        # Calculate IN[B] = USE[B] Union (OUT[B] - DEF[B])
        new_in = USE[block].union(OUT[block] - DEF[block])
        
        # Check if the IN set changed to determine if we need another pass
        if new_in != IN[block]:
            IN[block] = new_in
            changed = True

# --- PRINTING THE RESULTS ---
def format_set(s):
    return '{' + ', '.join(sorted(s)) + '}' if s else '{}'

print("--- Live Variable Analysis Results ---")
print(f"{'Block':<6} | {'DEF':<10} | {'USE':<10} | {'IN':<10} | {'OUT':<10}")
print("-" * 55)

for block in CFG:
    print(f"{block:<6} | {format_set(DEF[block]):<10} | {format_set(USE[block]):<10} | {format_set(IN[block]):<10} | {format_set(OUT[block]):<10}")