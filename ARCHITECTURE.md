# PhoenixFullStack

This document describes the general architecture of the project. It helps you find the wanted code fragment you want to work on.

## Templates vs. code

The project is split into two parts:

1. Templates for the newly create project
2. Elixir code to copy and modify them

The templates are in the `templates/` directory and organized by their purpose. A 
template can be a file that is copied 1:1 or a file containing `eex` directives like
`<%= app_module %>`.

The elixir code starts as the mix task `Mix.Tasks.FullStack.New` and invokes modules from
`PhoenixFullStack.Modify`. These modules load the templates and copy them to the final path.

### Templates

A mix task cannot have any resources like a compiled `.jar` containing them inside
its `.jar`, which is essential just a `.zip`. The solution is to read the template files
at compile time and store the content as the return value of a function. The function
itself is pattern-matched by the path.
