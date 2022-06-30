#define INIT_STACK() asm volatile(".section .bss");\
                    asm volatile(".lcomm KERNEL_STACK_TOP, 16384");\
                    asm volatile("KERNEL_STACK_BOTTOM:");\
                    asm volatile(".section .text");

#define HLT() asm volatile("hlt")

int stage1()
{
    
    INIT_STACK();
    
    return -1;
}
