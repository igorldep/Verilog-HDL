
#include "system.h"
#include "basic_io.h"
#include "LCD.h"
#include "sys/alt_irq.h"

//  for USB
#include "BASICTYP.H"
#include "COMMON.H"
#include "ISR.H"
#include "USB.H"
#include "MAINLOOP.H"
#include "ISR.C"
#include "HAL4D13.C"
#include "CHAP_9.C"
#include "D13BUS.C"
#include "ISO.C"
#include "USB_IRQ.C"
#include "MAINLOOP.C"

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

//-------------------------------------------------------------------------
//  Global Variable
D13FLAGS bD13flags;
USBCHECK_DEVICE_STATES bUSBCheck_Device_State;
CONTROL_XFER ControlData;
IO_REQUEST idata ioRequest;
//-------------------------------------------------------------------------
int main(void)
{
    LCD_Test();
    disable();
    disconnect_USB();
    usleep(1000000);
    Hal4D13_ResetDevice();
    bUSBCheck_Device_State.State_bits.DEVICE_DEFAULT_STATE = 1;
    bUSBCheck_Device_State.State_bits.DEVICE_ADDRESS_STATE = 0;
    bUSBCheck_Device_State.State_bits.DEVICE_CONFIGURATION_STATE = 0;
    bUSBCheck_Device_State.State_bits.RESET_BITS = 0;  
    usleep(1000000);
    reconnect_USB(); 
    CHECK_CHIP_ID();
    Hal4D13_AcquireD13(ISP1362_IRQ_1,(void*)usb_isr);
    enable();
    bD13flags.bits.verbose=1;
    while (1)
    {
      if (bUSBCheck_Device_State.State_bits.RESET_BITS == 1)
      {
        disable();
        break;  
      }
      if (bD13flags.bits.suspend)
      {
        disable();
        bD13flags.bits.suspend= 0;
        enable();
        suspend_change();    
      } // Suspend Change Handler
      if (bD13flags.bits.DCP_state == USBFSM4DCP_SETUPPROC)
      {
        disable();
        SetupToken_Handler();
        enable();
      } // Setup Token Handler 
      if ((bD13flags.bits.DCP_state == USBFSM4DCP_REQUESTPROC) && !ControlData.Abort)
      {
        disable();
        bD13flags.bits.DCP_state = 0x00;
        DeviceRequest_Handler();
        enable();
      } // Device Request Handler
      usleep(1);
    }
  return  0;
}

//-------------------------------------------------------------------------


