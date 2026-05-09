---
name: add-comment
description: Add clear, explanatory comments to SQL queries and scripts to improve readability and maintainability
---

# Add Comments to SQL Code

## When to Use
Invoke this skill when the user asks to add comments, document, or annotate SQL queries, scripts, or stored procedures.

## Instructions

1. Read the target SQL file or code provided by the user.
2. Analyze the SQL to understand:
   - The overall purpose of the query or script
   - What each CTE, subquery, or major clause does
   - Any complex logic, filters, joins, or transformations that benefit from explanation
   - Business context where inferable (e.g., column names like `churn_flag`, `revenue`)
3. Add comments using standard SQL comment syntax:
   - Use `--` for single-line comments
   - Use `/* ... */` for multi-line block comments describing overall query purpose
   - Place a block comment at the top summarizing the query's goal
   - Add inline `--` comments next to non-obvious joins, filters, calculations, and aggregations
4. Follow these style guidelines:
   - Keep comments concise and meaningful — avoid restating the obvious (e.g., don't write `-- select all columns` above `SELECT *`)
   - Focus on the **why** and **what**, not the **how** when the SQL is self-explanatory
   - Use consistent casing and formatting that matches the existing code style
   - Do not alter the SQL logic — only add comments
   - Always write comments in Japanese, except inside code blocks or when English is explicitly more appropriate (e.g., technical terms, standard abbreviations, or when the user requests English)
5. Save the updated file using Edit (append or modify in place).
