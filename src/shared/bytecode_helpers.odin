package shared

import "core:encoding/base64"
import "core:strings"

// Check if the string is a Thorium source script (.th)
is_script :: proc(data: cstring) -> bool {
    words := strings.split(string(data), "")
    defer delete(words)
    for word in words {
        if word == "@module" {
            return true
        }
    }
    return false
}

// Check if the string is human-readable bytecode (.thb)
is_vm_human_readable :: proc(data: cstring) -> bool {
    text := string(data)
    // Must start with '[' and contain at least one quoted string (module name)
    if  !strings.starts_with(text, "[") {
        return false
    }
    if strings.contains(text, "\"") && strings.contains(text, "[") {
        return true
    }
    return false
}

// Check if the string is a compiled VM program (.thprg)
is_vm_program :: proc(data: cstring) -> bool {
    text := string(data)
    // Should start with '[' but contain mostly numeric IDs (no quotes)
    if !strings.starts_with(text, "[") {
        return false
    }
    if !strings.contains(text, "\"") && strings.contains(text, ",") {
        return true
    }
    return false
}


// encodes a string to Base64
str_encoder :: proc(str: cstring) -> cstring {
    encoded := base64.encode(transmute([]byte)string(str), allocator = context.temp_allocator)
    return strings.clone_to_cstring(encoded, context.temp_allocator)
}

// decodes a string from Base64
str_decoder :: proc(str: cstring) -> cstring {
    decoded := base64.decode(string(str), allocator = context.temp_allocator)
    return strings.clone_to_cstring(cast(string)decoded, context.temp_allocator)
}