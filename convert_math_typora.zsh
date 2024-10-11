#!/bin/zsh

# Script: convert_math_typora.zsh
# Purpose: Convert mathematical formulas in Markdown files to be compatible with Typora.
# Specifically, it replaces \[ and \] with $ within tables, but leaves them untouched elsewhere.
# This script was originally designed to take the LaTeX integration from ChatGPT and convert it to Typora-friendly formatting.
# Usage:
#   ./convert_math_typora.zsh [input_file] [output_file]
#   If no input and output files are specified, reads from standard input and writes to standard output.
#   Options:
#     -h, --help    Display this help message.

# Function to display help message
display_help() {
    echo "Usage: $0 [input_file] [output_file]"
    echo "Convert mathematical formulas in Markdown files to be compatible with Typora."
    echo
    echo "Options:"
    echo "  -h, --help    Display this help message."
    echo
    echo "If no input and output files are specified, reads from standard input and writes to standard output."
    exit 0
}

# Check for help option
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    display_help
fi

input_file=""
output_file=""

# Handle arguments
if [[ $# -eq 2 ]]; then
    input_file="$1"
    output_file="$2"
elif [[ $# -eq 0 ]]; then
    input_file="-"
    output_file="-"
else
    echo "Invalid arguments."
    display_help
fi

# Check if input file exists unless reading from stdin
if [[ "$input_file" != "-" && ! -f "$input_file" ]]; then
    echo "Error: Input file '$input_file' does not exist."
    exit 1
fi

# If output file is specified and exists, prompt before overwriting
if [[ "$output_file" != "-" && -f "$output_file" ]]; then
    echo -n "Output file '$output_file' already exists. Overwrite? [y/N]: "
    read answer
    if [[ "$answer" != [Yy] ]]; then
        echo "Operation cancelled."
        exit 1
    fi
fi

# Initialize state variable
in_code_block=false

# Define regex patterns
code_fence_pattern='^(```|~~~)'
table_line_pattern='\|'

# Read the input file line by line
if [[ "$input_file" == "-" ]]; then
    # Read from stdin
    input_stream="/dev/stdin"
else
    input_stream="$input_file"
fi

# Write to output file or stdout
if [[ "$output_file" == "-" ]]; then
    output_stream="/dev/stdout"
else
    output_stream="$output_file"
    # Create or empty the output file
    > "$output_file"
fi

while IFS= read -r line; do
    # Detect the start or end of a code block
    if [[ "$line" =~ $code_fence_pattern ]]; then
        # Toggle the in_code_block state
        in_code_block=$(( ! $in_code_block ))
        # Write the code fence line as is
        echo "$line" >> "$output_stream"
        continue
    fi

    # If inside a code block, write the line as is
    if [[ $in_code_block == 1 ]]; then
        echo "$line" >> "$output_stream"
        continue
    fi

    # Check if the line is part of a table (contains '|')
    if [[ "$line" =~ $table_line_pattern ]]; then
        # Replace all occurrences of \[ and \] with $
        modified_line="${line//\\[/\$}"
        modified_line="${modified_line//\\]/\$}"
        echo "$modified_line" >> "$output_stream"
    else
        # For lines outside tables, keep display math as \[ ... \]
        echo "$line" >> "$output_stream"
    fi
done < "$input_stream"

if [[ "$output_file" != "-" ]]; then
    echo "Conversion complete. Output saved to '$output_file'."
fi
