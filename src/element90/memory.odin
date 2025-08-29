package main

import "core:fmt"

DEFAULT_STACK_SIZE :: 1 * 1024 * 1024 // 1 MiB

// Default arena settings
DEFAULT_ARENA_CHUNK_SIZE :: 1 * 1024 * 1024   // 1 MiB per chunk
DEFAULT_ARENA_MAX_CHUNKS :: 16                // max number of chunks

// Thorium VM stack structure (1 MB by default)
Stack :: struct {
    size:  uint,   // total size of the stack (bytes)
    used:  uint,   // how many bytes are currently used
    raw_data:  []i128, // underlying stack buffer

    // Push a single byte onto the stack
    push: proc(stack: ^Stack, value: i128),

    // Pop a single byte off the stack
    pop: proc(stack: ^Stack) -> i128,

    // Swap the top two elements on the stack
    swap: proc(stack: ^Stack),
}

default_push :: proc(using stack: ^Stack, value: i128) {
    if used >= size {
        fmt.eprintln("ELEMENT90.CRITICAL.MEMORY.STACK.OVERFLOW!")
        return
    }
    raw_data[used] = value
    used += 1
}

default_pop :: proc(using stack: ^Stack) -> i128 {
    if used == 0 {
        fmt.eprintln("ELEMENT90.CRITICAL.MEMORY.STACK.UNDERFLOW!")
        return 0
    }
    used -= 1
    return raw_data[used]
}

default_swap :: proc(using stack: ^Stack) {
    if used < 2 {
        fmt.eprintln("ELEMENT90.CRITICAL.MEMORY.STACK.SWAP_LT2")
        return
    }

    top    := used - 1
    second := used - 2

    tmp := raw_data[top]
    raw_data[top] = raw_data[second]
    raw_data[second] = tmp
}

// Initialize a stack with a given size
init_stack :: proc(size: uint = DEFAULT_STACK_SIZE, push_proc := default_push, pop_proc := default_pop, swap_proc := default_swap) -> ^Stack {
    stack := new(Stack)
    stack.size = size
    stack.used = 0
    stack.raw_data = make([]i128, size)
    stack.push = push_proc
    stack.pop = pop_proc
    stack.swap = swap_proc
    return stack
}

destroy_stack :: proc(stack: ^Stack) {
    free(stack)
}

Chunk :: struct {
    size: uint ,     // total size in bytes
    used: uint,      // bytes currently allocated
    free: uint,      // bytes currently free
    data: []byte     // memory buffer
}

Heap :: struct {

}