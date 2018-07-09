DE2_SD_Card_Audio
-----------------

This designs uses a Nios II system to demonstrate how to read from the SD card. The software reads WAV files from the SD card and plays it through the LINE OUT line. Simply put a SD card into the slot on the board and connect some speakers to the LINE OUT port.

Preparing the SD card
---------------------

To prepare the SD card for reading by the design, it should be formatted using a FAT16 file system. Then WAV files can be copied on to the card. Note that if you want to add a file after you've removed the card from the computer, you must reformat the card first and then re-add the files.

Running the Design
------------------

1) Launch the Quartus II software.
2) Open the DE2_SD_Card_Audio.qpf project located in the <install path>\DE2_SD_Card_Audio folder. (File menu -> Open Project)
3) Open the Programmer window. (Tools menu -> Programmer)
4) The DE2_SD_Card_Audio.sof programming file should be listed.
   Check the 'Program/Configure' box and set up the JTAG programming hardware connection via the 'Hardware Setup' button.
5) Press 'Start' to start programming. The design should now be programmed.
6) Launch the Nios II IDE.
7) Switch the workspace to the <install path>\DE2_SD_Card_Audio folder.
8) Build the project. (Project menu -> Build All)
9) Run the project on the board. (Run menu)

User Inputs to the Design
-------------------------

None.

Compiling the Design
--------------------

1) Launch the Quartus II software.
2) Open the DE2_SD_Card_Audio.qpf project located in the <install path>\DE2_SD_Card_Audio folder. (File menu -> Open Project)
3) Start compilation. (Processing -> Start Compilation)
4) After compilation is finished, you can run the design with the generated SOF file. See 'Running the Design' above, which includes steps to build the Nios II project.
