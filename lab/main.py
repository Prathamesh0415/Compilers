import re

def compute_use_def(cfg):
    use_sets = {}
    def_sets = {}
    
    # Regex pattern to match variable names (starts with letter/underscore, followed by alphanumerics)
    # This automatically ignores raw numbers and math operators.
    var_pattern = re.compile(r'\b[a-zA-Z_][a-zA-Z0-9_]*\b')

    for block_name, block_data in cfg.items():
        current_use = set()
        current_def = set()
        
        for stmt in block_data['stmts']:
            # Handle return statements (e.g., "return c")
            if stmt.startswith("return "):
                expr = stmt[7:] # Extract everything after "return "
                vars_in_expr = set(var_pattern.findall(expr))
                
                for var in vars_in_expr:
                    # Only add to USE if it hasn't been locally defined first
                    if var not in current_def:
                        current_use.add(var)
            
            # Handle assignment statements (e.g., "c = a + b")
            elif "=" in stmt:
                lhs, rhs = stmt.split("=", 1)
                
                # 1. Process Uses (Right-Hand Side) FIRST
                vars_in_rhs = set(var_pattern.findall(rhs))
                for var in vars_in_rhs:
                    if var not in current_def:
                        current_use.add(var)
                
                # 2. Process Definitions (Left-Hand Side)
                # Assuming a single variable assignment on the LHS
                vars_in_lhs = set(var_pattern.findall(lhs))
                for var in vars_in_lhs:
                    current_def.add(var)
        
        # Store the computed sets for the block
        use_sets[block_name] = current_use
        def_sets[block_name] = current_def

    return use_sets, def_sets

# --- Execution ---

CFG = { 
    'B1': {'stmts': ["a = 5", "b = 10"], 'succ': ['B2']}, 
    'B2': {'stmts': ["c = a + b"], 'succ': ['B3']}, 
    'B3': {'stmts': ["d = c + 2"], 'succ': ['B4']}, 
    'B4': {'stmts': ["e = d + 1"], 'succ': ['B5']}, 
    'B5': {'stmts': ["return c"], 'succ': []} 
}

use_sets, def_sets = compute_use_def(CFG)

print("Block\tUSE Set\t\tDEF Set")
print("-" * 40)
for block in CFG.keys():
    use_str = str(use_sets[block]) if use_sets[block] else "{}"
    def_str = str(def_sets[block]) if def_sets[block] else "{}"
    print(f"{block}\t{use_str:<15}\t{def_str}")