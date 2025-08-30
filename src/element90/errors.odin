package main

import "core:fmt"
// Stack snapshot before and after an operation
StackComp :: struct {
    before_op: Stack,    // stack state before the operation
    after_op: Stack,     // stack state after the operation
}

// Traceback information for exceptions
Traceback :: struct {
    last_instruction: cstring,   // textual description of last executed instruction
    comp: StackComp,             // stack snapshot
}

// Different types of exceptions the VM can generate
ExceptionType :: enum {
    NONE,          // no exception
    MEMORY,        // stack or heap errors
    TYPE,          // type mismatch
    WRONG_OP,      // invalid operation
    FFI,           // external function/foreign interface error
    USER_CALLED,   // planned: user-triggered exception (throw/catch)
}

// Full exception structure
Exception :: struct {
    type: ExceptionType,
    trace: Traceback,
}

Throw :: proc(type: ExceptionType, trace: Traceback) -> Exception {
    exeption: Exception
    exeption.trace = trace
    exeption.type = type

    return exeption
}

OutputExeption :: proc(exeption: Exception) {
    fmt.eprintfln("ELEMENT90.ERROR.%s.THROWABLE", exeption.type)
    fmt.eprintfln("STACK_BEFORE: %#v\nSTACK_AFTER: %#v\n INSTRUCTION: %#v", exeption.trace.comp.before_op, exeption.trace.comp.after_op, exeption.trace.last_instruction)
}

CRASH_AND_BURN :: proc(vm_shutdown_proc: proc(vm: ^VMContext), cleanup_proc: proc(vm: ^VMContext)) {
    
}