####
Jira
####

Searching
=========

Search for exact string
-----------------------
If you want to search for the **exact** string `Jira is good` in a comment, use the below query.
This works for other fields, of course, like `text` or `description`.
```jql
comment ~ "\"Jira is good\"~0"
```