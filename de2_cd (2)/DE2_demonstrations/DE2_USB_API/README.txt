DE2_USB_API
-----------

This design contains hardware and software that allows you to test various components on the board, including the LEDs, 7-segment displays, SRAM, SDRAM, Flash, and the VGA port. All of this is done via a software interface running on your computer. The JTAG USB link on the board is used to communicate between the hardware circuit and the software program.

Running the Design
------------------

1) Launch the Quartus II software.
2) Open the DE2_USB_API.qpf project located in the <install path>\DE2_USB_API\HW folder. (File menu -> Open Project)
3) Open the Programmer window. (Tools menu -> Programmer)
4) The DE2_USB_API.sof programming file should be listed.
   Check the 'Program/Configure' box and set up the JTAG programming hardware connection via the 'Hardware Setup' button.
5) Press 'Start' to start programming. The design should now be programmed and running.
6) Run the DE2_Control_Panel.exe program located in the <install path>\DE2_USB_API\SW folder.
7) Connect to the board using the 'Open USB Port <#>' menu option under the 'Open' menu.
8) See the DE2 User Manual for more information about the software interface.

User Inputs to the Design
-------------------------

KEY0: resets the circuit

Compiling the Design
--------------------

1) Launch the Quartus II software.
2) Open the DE2_USB_API.qpf project located in the <install path>\DE2_USB_API\HW folder. (File menu -> Open Project)
3) Start compilation. (Processing -> Start Compilation)
4) After compilation is finished, you can run the design with the generated SOF file. See 'Running the Design' above.
