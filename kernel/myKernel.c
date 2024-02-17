
#include "../drivers/headers/screen.h"


#if defined(__linux__)
#error "pls use cross compiler"
#endif

#if !defined(__i386__)
#error "pls use i686"
#endif



void main(void) {
    terminal_initialize();
    
    terminal_writestring(" _   _       _ _         \n");
    terminal_writestring("| | | | ___ | | | ___    \n");
    terminal_writestring("| |_| |/ _ \\| | |/ _ \\ \n");
    terminal_writestring("|  _  |  __/| | | (_) |  \n");
    terminal_writestring("|_| |_|\\___||_|_|\\___/ \n");
    

 
   
}