
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
 
    .data : 
    { 
        *(.data)
    }

    .text :
    { 
    
        *(.text) 

        *(.rodata)
         
    }
}
