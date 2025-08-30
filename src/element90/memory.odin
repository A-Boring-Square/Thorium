package main

import "core:fmt"

DEFAULT_STACK_SIZE :: 1 * 1024 * 1024      // 1 MiB
DEFAULT_ARENA_CHUNK_SIZE :: 1 * 1024 * 1024 // 1 MiB per chunk
DEFAULT_ARENA_MAX_CHUNKS :: 16

// ------------------------------------
// Stack
// ------------------------------------
Stack :: struct {
    size: uint,
    used: uint,
    raw_data: []i128,

    push: proc(using stack: ^Stack, value: i128),
    pop: proc(using stack: ^Stack) -> i128,
    swap: proc(using stack: ^Stack),
    dump: proc(using stack: ^Stack, use_stderr: bool)
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
    tmp := raw_data[used - 1]
    raw_data[used - 1] = raw_data[used - 2]
    raw_data[used - 2] = tmp
}

dump_stack :: proc(using stack: ^Stack, use_stderr: bool) {
    if use_stderr {
        fmt.eprintfln("ELEMENT90.INFO.MEMORY.STACK.DUMP\n%#v", raw_data)
    } else {
        fmt.printfln("ELEMENT90.INFO.MEMORY.STACK.DUMP\n%#v", raw_data)
    }
}

init_stack :: proc(size: uint = DEFAULT_STACK_SIZE) -> ^Stack {
    stack := new(Stack)
    stack.size = size
    stack.used = 0
    stack.raw_data = make([]i128, size)
    stack.push = default_push
    stack.pop = default_pop
    stack.swap = default_swap
    stack.dump = dump_stack
    return stack
}

destroy_stack :: proc(stack: ^Stack) {
    free(stack)
}

// ------------------------------------
// Arena Heap
// ------------------------------------
Chunk :: struct {
    size: uint,
    used: uint,
    free: uint,
    data: []byte,
    id: uint
}

Heap :: struct {
    chunks_count: uint,
    chunks: []^Chunk,
    working_chunk: ^Chunk,
    next_chunk_id: uint,

    alloc: proc(using heap: ^Heap, n: uint) -> (size: uint, chunk_id: uint, offset: uint),
    free_all: proc(using heap: ^Heap)
}

default_alloc :: proc(using heap: ^Heap, n: uint) -> (uint, uint, uint) {

    // Check if allocation is larger than max chunk size
    if n > DEFAULT_ARENA_CHUNK_SIZE {
        fmt.eprintfln("ELEMENT90.CRITICAL.MEMORY.HEAP.ALLOC.SIZE_EXCEEDS_CHUNK: requested %d bytes, max %d", n, DEFAULT_ARENA_CHUNK_SIZE)
        return 0, 0, 0
    }

    // Allocate new chunk if needed
    if working_chunk == nil || working_chunk.free < n {
        if chunks_count >= DEFAULT_ARENA_MAX_CHUNKS {
            fmt.eprintfln("ELEMENT90.CRITICAL.MEMORY.HEAP.ALLOC.MAX_CHUNKS_REACHED: cannot allocate %d bytes", n)
            return 0, 0, 0
        }

        new_chunk := new(Chunk)
        new_chunk.size = max(DEFAULT_ARENA_CHUNK_SIZE, n)
        new_chunk.used = 0
        new_chunk.free = new_chunk.size
        new_chunk.data = make([]byte, new_chunk.size)
        new_chunk.id = next_chunk_id
        if VM_DEBUG_MODE {
            fmt.printfln("ELEMENT90.DEBUG.MEMORY.HEAP.ALLOC.NEW_CHUNK: id=%d size=%d", new_chunk.id, new_chunk.size)
        }

        next_chunk_id += 1
        chunks[next_chunk_id] = new_chunk          // append to chunks array
        working_chunk = new_chunk
        chunks_count += 1
    }

    // Allocate from the working chunk
    offset := working_chunk.used
    working_chunk.used += n
    working_chunk.free = working_chunk.size - working_chunk.used
    if VM_DEBUG_MODE {
        fmt.printfln("ELEMENT90.DEBUG.MEMORY.HEAP.ALLOC: allocated %d bytes at chunk=%d offset=%d", n, working_chunk.id, offset)
    }
    return n, working_chunk.id, offset
}

default_free_all :: proc(using heap: ^Heap) {
    for chunk in chunks {
        delete(chunk.data)
        free(chunk)
    }
    chunks = nil
    working_chunk = nil
    chunks_count = 0
    next_chunk_id = 0
}

init_heap :: proc(prealloc_chunk_amount: uint, max_chunks := DEFAULT_ARENA_MAX_CHUNKS, heap_alloc := default_alloc, heap_free_all := default_free_all) -> ^Heap {
    heap := new(Heap)
    heap.chunks_count = 0
    heap.chunks = make([]^Chunk, max_chunks)
    heap.working_chunk = nil
    heap.next_chunk_id = 0
    heap.alloc = heap_alloc
    heap.free_all = heap_free_all
    return heap
}

destroy_heap :: proc(heap: ^Heap) {
    free(heap)
}