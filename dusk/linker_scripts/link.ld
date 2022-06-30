
ENTRY(stage0)
OUTPUT_FORMAT("binary")

SECTIONS
{
  
    . = 0x7c00; /* the BIOS loads us here */
  
    .boot : 
    {
        *(.boot)
  
        . = 510;
        
        SHORT(0xaa55); /* MBR signature */
    }
 
    .text :
    { 
    
        *(.text) 

        *(.rodata)
         
        FILL(0xaa);
    }

    .data : 
    { 
        *(.data)
    }
}
