



void falseEntry(){
    char* vid_mem = (char*)0xb8020;
    const char* fal="im not the entry";
    for(int i=0; i<16; i++) {
        vid_mem[i*2] = fal[i];
        vid_mem[i*2 +1] = 0xa;
        
    }

}

int myfunc() {
    const char* greeting = "hello my brother";
    char* vid_mem = (char*)0xb8000;
    for(int i=0; i<16; i++) {
        vid_mem[i*2] = greeting[i];
        vid_mem[i*2 +1] = 0x0f;

    }
    falseEntry();
}