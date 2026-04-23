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

# --- STEP 1 & 2: Calculate USE, DEF, and LVA (from Q1 & Q2) ---
USE = {}
DEF = {}
for block, data in CFG.items():
    block_def, block_use = set(), set()
    for stmt in data['stmts']:
        stmt_def, stmt_use = set(), set()
        if '=' in stmt:
            lhs, rhs = stmt.split('=', 1)
            stmt_def, stmt_use = extract_variables(lhs), extract_variables(rhs)
        else:
            stmt_use = extract_variables(stmt)
            
        block_use.update(u for u in stmt_use if u not in block_def)
        block_def.update(stmt_def)
            
    USE[block] = block_use
    DEF[block] = block_def

IN = {block: set() for block in CFG}
OUT = {block: set() for block in CFG}

changed = True
while changed:
    changed = False
    for block in reversed(list(CFG.keys())):
        new_out = set()
        for succ in CFG[block]['succ']:
            new_out.update(IN[succ])
        OUT[block] = new_out
        
        new_in = USE[block].union(OUT[block] - DEF[block])
        if new_in != IN[block]:
            IN[block] = new_in
            changed = True

# --- STEP 3: Perform Dead Code Analysis ---
optimized_CFG = {}
dead_code_found = []

for block, data in CFG.items():
    # Start liveness at the end of the block using the OUT set
    current_live = set(OUT[block])
    kept_stmts = []
    
    # Traverse statements backward inside the block
    for stmt in reversed(data['stmts']):
        if '=' in stmt:
            lhs, rhs = stmt.split('=', 1)
            defs = extract_variables(lhs)
            uses = extract_variables(rhs)
            
            # If the assigned variable is NOT live, this is Dead Code!
            # (Assuming single assignments per line like 'x = y + z')
            is_dead = True
            for d in defs:
                if d in current_live:
                    is_dead = False
                    break
                    
            if is_dead:
                dead_code_found.append((block, stmt))
            else:
                kept_stmts.append(stmt)
                # Update current liveness: remove the def, add the uses
                current_live.difference_update(defs)
                current_live.update(uses)
        else:
            # Statements with no assignment (e.g., 'return') are kept
            kept_stmts.append(stmt)
            current_live.update(extract_variables(stmt))
            
    # Reverse the kept statements to restore original execution order
    kept_stmts.reverse()
    optimized_CFG[block] = {'stmts': kept_stmts, 'succ': data['succ']}

# --- PRINTING THE RESULTS ---
print("--- Dead Code Detected ---")
if not dead_code_found:
    print("No dead code found.")
else:
    for block, stmt in dead_code_found:
        print(f"Removed '{stmt}' from {block}")

print("\n--- Optimized CFG ---")
for block, data in optimized_CFG.items():
    print(f"{block}: {data['stmts']}")