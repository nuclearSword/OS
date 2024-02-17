
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "headers/port.h"





#define VGA_BUFFER 0xb8000

#define REG_SCR_CTRL 0x3d4
#define REG_SCR_DATA 0x3d5

#define CURSOR_HIGH_BYTE 0xE
#define CURSOR_LOW_BYTE 0xF

#define VGA_WIDTH 80
#define VGA_HEIGHT 25

enum vga_color {
    VGA_COLOR_BLACK = 0,
    VGA_COLOR_BLUE = 1,
    VGA_COLOR_GREEN = 2,
    VGA_COLOR_CYAN = 3,
    VGA_COLOR_RED = 4,
    VGA_COLOR_MAGENTA = 5,
    VGA_COLOR_BROWN = 6,
    VGA_COLOR_LIGHT_GREY = 7,
    VGA_COLOR_WHITE = 15,
};




static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg ) {
    return fg | bg << 4;
}

static inline uint16_t vga_entry(unsigned char uc, uint8_t color ) {
    return (uint16_t) uc | (uint16_t) color << 8;
}

size_t strlen(const char* str ){   
    size_t len = 0;
    while( str[len]) {
        len++;
    }
    return len;
}
void mem_cpy(char* src, char* dest, size_t size) {
    for(size_t i=0; i < size; i++) {
        dest[i] = src[i];
    }
}



size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t* terminal_buffer; 


int get_cursor() {
    int pos;
    /*reading high byte of cursor pos*/
    port_byte_out(REG_SCR_CTRL, CURSOR_HIGH_BYTE); 
    pos = port_byte_in(REG_SCR_DATA) << 8;

    /*reading high byte of cursor pos*/
    port_byte_out(REG_SCR_CTRL, CURSOR_LOW_BYTE); 
    pos += port_byte_in(REG_SCR_DATA);
    return pos;
}
void set_cursor_at(size_t row , size_t column) {   
    int pos = row * VGA_WIDTH + column;
    port_byte_out(REG_SCR_CTRL, CURSOR_HIGH_BYTE);
    port_byte_out(REG_SCR_DATA, (unsigned char)(pos >> 8));
    port_byte_out(REG_SCR_CTRL, CURSOR_LOW_BYTE);
    port_byte_out(REG_SCR_DATA, (unsigned char)(pos & 0xff));

    

}
void update_cursor() {
    int xd = get_cursor();
    set_cursor_at(terminal_row, terminal_column);
}

void clear_terminal() {
    for (size_t y = 0; y < VGA_HEIGHT; y++) {
        for(size_t x = 0; x < VGA_WIDTH; x++) {
            const  size_t index = y*VGA_WIDTH + x;
            terminal_buffer[index] = vga_entry(' ', terminal_color);
        }
    }
}

void terminal_initialize() {
    terminal_row = 0;
    terminal_column = 0;
    terminal_color = vga_entry_color(VGA_COLOR_WHITE, VGA_COLOR_BLACK);
    terminal_buffer = (uint16_t*) 0xb8000 ;
    clear_terminal();
    update_cursor();

}

void terminal_setcolor(uint8_t color) {
    terminal_color = color ;
}
void terminal_endl() {
    terminal_row++;
    terminal_column=0;
}
void terminal_putentryat(char c, size_t row, size_t column) {
    const size_t index = row * VGA_WIDTH + column;
    terminal_buffer[index] = vga_entry(c, terminal_color);
}
void terminal_putchar(char c) {
    if(c == '\n')  {
        terminal_endl() ;
        return ;
    }
    terminal_putentryat(c, terminal_row, terminal_column);

    if (++terminal_column < VGA_WIDTH) 
        return ;

    terminal_column = 0 ;
    if (++terminal_row < VGA_HEIGHT)
        return;
    terminal_row -= 1;
    size_t size = 2*(terminal_row*VGA_HEIGHT + terminal_column);
    mem_cpy((char*)terminal_buffer +VGA_WIDTH ,(char*)terminal_buffer, size ) ;

}
void terminal_write(const char* data, size_t size) {
    for(size_t i = 0; i < size; i++) {
        terminal_putchar(data[i]);
        
        update_cursor();
    }
}  
void terminal_writestring(const char* data) {
    terminal_write(data, strlen(data));
} 



