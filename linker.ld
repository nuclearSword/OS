ENTRY(main)

SECTIONS {
    . = 1000;
    .text BLOCK(4k) : ALIGN(4K) {
        *(.text)
    }

    .rodate BLOCK(4K) : ALIGN(4K) {
        *(.data)
    }

    .bss BLOCK(4k) : ALIGN(4k) {
        *(COMMON)
        *(.bss)
    }
}