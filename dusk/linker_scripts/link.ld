ENTRY(stage0)
OUTPUT_FORMAT("binary")
SECTIONS
{

  .boot : {
    *(.boot)
  
  . = 510;
  SHORT(0xaa55);
 }
 
  .text : { 

    
  *(.text) 

    *(.rodata)
    }
  .data : { 
    *(.data)
     }
}
    
