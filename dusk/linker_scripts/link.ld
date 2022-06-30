ENTRY(stage0)
OUTPUT_FORMAT("binary")
SECTIONS
{
  . = 0x7c00;
  .boot : {
    *(.boot)
  
  . = 510;
  SHORT(0xaa55);
 }
 
  .text : { 
    
    
  *(.text) 

    *(.rodata)
         
    FILL(0xaa);
}
  .data : { 
    *(.data)
    }
    .= 0xffff;
}
    
