ChelomEx
========

Software for the isotope assisted discovery of metal chelating agents from high-resolution LC-MS data
ChelomEx is implemented in MatLab R2013b

To start the ChelomEx GUI from MatLab type ChelomEx_Menu from the MatLab prompt. 

The program includes the following files:

Graphical User Interfaces
ChelomEx_Menu.m  ---  Main GUI
ChelomEx_pattern_figure.m --- Visualization of pattern matched isotope cluster groups
ChelomEx_peak_figure.m --- Visualization of pattern matched chromatographic features
ChelomEx_open_run_menu.m --- Import of mzXML files
ChelomEx_pattern_definition.m --- Definition of isotope patterns and related adducts
ChelomEx_pattern_definition_isotopes.m --- Definition of an individual isotope
ChelomEx_id_database.m --- Database search
ChelomEx_search_manual.m --- Targeted istope pattern search using a manual entry for the monoisotope of a metal complex or free ligand
ChelomEx_parameters_filters.m --- Definition of parameters to remove false positive after chromatographic coherence analysis of isotope patterns ...                      %  "
       
Individual functions --- see description in the files
search_Pattern.m 
find_pattern.m 
group_pattern.m 
ptrn2pk_species.m 
ptrn2pk.m... 
search_species.m 
save_results.m
plot_pattern.m 
plotms.m                                                  
mzxmlimport.m 
mzxmlread.m
eic.m 
existMSMS.m 
vcompare.m 
totalionc.m 
findPeaks.m
findapoMS2.m 
sort_results_pks.m 
FindSpecies.m
get_db_species.m 
dbcompare_pks.m
datacursorfcn.m 
hsl2rgb.m 
rgb2hsl.m 
existMSMS.m 
      
Additional files
default_parameters.mat  --- contains default parameter values 
startup_parameters.mat --- contains parameter values that are loaded at startup
database.mat --- contains the compound library used in ChelomEx 

pngs and jpgs used in the GUI
ArrowDown.png, ArrowLeft.png, ArrowRight.png, ArrowUp.png, OpenFile.png, Chelon.png, Arrow_LaunchFigure.jpg
