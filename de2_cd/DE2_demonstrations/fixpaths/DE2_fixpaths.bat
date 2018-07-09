@echo This batch file will run an utility to help you update the paths in the DE2 demonstration files. A dialog window will appear where you can select the folder that contains the DE2 demonstration files.

@fixpath -opath "c:\de2" -projdir "DE2_*" -sprompt "Select the directory containing the DE2 demonstration project files."

