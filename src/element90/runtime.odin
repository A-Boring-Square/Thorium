package main

Scope :: struct {
    var_table: map[int]cstring,
    operator_list: []cstring,
    internal_scope: ^Scope,
}

VMContext :: struct {
    heap: ^Heap,
    stack: ^Stack,
    globals: map[int]cstring,
    first_scope: ^Scope,
    exeption: ^Exception,
}