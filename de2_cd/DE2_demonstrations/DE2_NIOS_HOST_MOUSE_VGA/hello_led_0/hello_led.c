
#include "system.h"
#include "basic_io.h"
#include "LCD.h"
#include "Test.h"
#include "sys/alt_irq.h"
#include "VGA.C"
#include "HAL4D13.C"


#include "isa290.h"
#include "reg.h"
#include "buf_man.h"
#include "port.h"
#include "usb.h"
#include "ptd.h"
#include "cheeyu.h"
#include "mouse.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <io.h>
#include <fcntl.h>
#include "mouse.c"
#include "cheeyu.c"
#include "ptd.c"
#include "usb.c"
#include "buf_man.c"
#include "reg.c"
#include "port.c"

unsigned int		hc_data;
unsigned int		hc_com;
unsigned int		dc_data;
unsigned int		dc_com;

int main(void)
{
  VGA_Ctrl_Reg vga_ctrl_set;
  
  vga_ctrl_set.VGA_Ctrl_Flags.RED_ON    = 1;
  vga_ctrl_set.VGA_Ctrl_Flags.GREEN_ON  = 1;
  vga_ctrl_set.VGA_Ctrl_Flags.BLUE_ON   = 1;
  vga_ctrl_set.VGA_Ctrl_Flags.CURSOR_ON = 1;
  
  Vga_Write_Ctrl(VGA_0_BASE, vga_ctrl_set.Value);
  Set_Pixel_On_Color(1023,1023,1023);
  Set_Pixel_Off_Color(0,0,512);
  Set_Cursor_Color(0,1023,0);
  LCD_Test();

  w16(HcReset,0x00F6);//reset      
  reset_usb();//config  
  mouse();
  return 0;
}

