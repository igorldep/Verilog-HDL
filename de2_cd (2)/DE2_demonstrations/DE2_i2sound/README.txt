DE2_i2sound
-----------

This design combines audio input from the microphone and line in signals and outputs the result to the line out signal. Connect a microphone to the MIC port, an audio source to the LINE IN port, and speakers/headphones to the LINE OUT port.

Running the Design
------------------

1) Launch the Quartus II software.
2) Open the DE2_i2sound.qpf project located in the <install path>\DE2_i2sound folder. (File menu -> Open Project)
3) Open the Programmer window. (Tools menu -> Programmer)
4) The DE2_i2sound.sof programming file should be listed.
   Check the 'Program/Configure' box and set up the JTAG programming hardware connection via the 'Hardware Setup' button.
5) Press 'Start' to start programming. The design should now be programmed and running.

User Inputs to the Design
-------------------------

KEY0: changes the volume of the output

Compiling the Design
--------------------

1) Launch the Quartus II software.
2) Open the DE2_i2sound.qpf project located in the <install path>\DE2_i2sound folder. (File menu -> Open Project)
3) Start compilation. (Processing -> Start Compilation)
4) After compilation is finished, you can run the design with the generated SOF file. See 'Running the Design' above.
