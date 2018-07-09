DE2_NIOS_HOST_MOUSE_VGA
-----------------------

This designs uses a Nios II system to demonstrate how to communicate with a USB device connected to the USB HOST port on the DE2 board. This design implements a monochrome display, with a preloaded image, where the user can draw on it with a mouse. A USB mouse should be connected to the USB HOST port and a CRT/LCD monitor should be connected to the VGA port.

Running the Design
------------------

1) Launch the Quartus II software.
2) Open the DE2_NIOS_HOST_MOUSE_VGA.qpf project located in the <install path>\DE2_NIOS_HOST_MOUSE_VGA folder. (File menu -> Open Project)
3) Open the Programmer window. (Tools menu -> Programmer)
4) The DE2_NIOS_HOST_MOUSE_VGA.sof programming file should be listed.
   Check the 'Program/Configure' box and set up the JTAG programming hardware connection via the 'Hardware Setup' button.
5) Press 'Start' to start programming. The design should now be programmed.
6) Launch the Nios II IDE.
7) Switch the workspace to the <install path>\DE2_NIOS_HOST_MOUSE_VGA folder.
8) Build the project. (Project menu -> Build All)
9) Run the project on the board. (Run menu)
10) Plug in a USB mouse into the USB HOST port on the board.

User Inputs to the Design
-------------------------

Mouse left click: draws a white dot
Mouse right click: draws a blue dot

Compiling the Design
--------------------

1) Launch the Quartus II software.
2) Open the DE2_NIOS_HOST_MOUSE_VGA.qpf project located in the <install path>\DE2_NIOS_HOST_MOUSE_VGA folder. (File menu -> Open Project)
3) Start compilation. (Processing -> Start Compilation)
4) After compilation is finished, you can run the design with the generated SOF file. See 'Running the Design' above, which includes steps to build the Nios II project.
