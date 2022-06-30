
#define HLT() asm volatile("hlt")

__cdecl
int stage1()
{
    
    HLT();    
    return -1;
}
