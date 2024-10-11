# Convert Math Typora Script

## Description

`convert_math_typora.zsh` is a shell script designed to process Markdown files and convert mathematical formulas to be compatible with [Typora](https://typora.io/). Specifically, it replaces `\[ ... \]` with `$ ... $` within Markdown tables, as Typora does not render display math inside tables correctly. The script leaves display math outside of tables untouched.

This script was originally designed to take the LaTeX integration from ChatGPT and convert it to Typora-friendly formatting.

## Features

- **Table Conversion**: Replaces `\[ ... \]` with `$ ... $` within tables for Typora compatibility.
- **Code Block Preservation**: Maintains the integrity of code blocks and code fences, leaving their content unaltered.
- **Selective Processing**: Only processes lines within tables, ensuring display math outside tables remains in its original form.
- **Standard Input/Output Support**: Can read from standard input and write to standard output when no files are specified.
- **Help Option**: Provides usage instructions with `-h` or `--help` flag.
- **Output File Confirmation**: Prompts before overwriting an existing output file to prevent accidental data loss.
- **Compatibility**: Written in zsh for macOS users.

## Requirements

- **zsh (Z Shell)**: Ensure you have zsh installed (default on macOS).
- **Permissions**: Execute permissions for the script.

## Installation

1. **Download the Script**

   Save the `convert_math_typora.zsh` script to your desired directory.

2. **Make the Script Executable**

   Open your terminal, navigate to the script's directory, and run:

   ```bash
   chmod +x convert_math_typora.zsh
