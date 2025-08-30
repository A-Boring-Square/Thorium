package main

import "core:debug/pe"
VM_DEBUG_MODE: bool


set_debug_mode :: proc(debug: bool) {
    VM_DEBUG_MODE = debug
}
