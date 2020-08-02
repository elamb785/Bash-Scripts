# Bash-Scripts
A Collection of Bash Scripts

# 1. math_is_fun.sh
Creates a mock quiz of various difficulties and various lengths. Handles improper input and returns results.

ISSUES: 
1. Unable to return * from get_operation because it expands contents of working directory so I
need to return x and then convert it to * later. Consider using escape characters.
2. No exit codes in program yet.
