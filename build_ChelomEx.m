mcc -v  -o ChelomEx_OSX_64bit...                                              % v=verbose, o=name, d=folder, -win32=optional;build 32-bit app
    -a default_parameters.mat -a startup_parameters.mat -a database.mat...            % additional files, not compiled
    -a ArrowDown.png -a ArrowLeft.png -a ArrowRight.png -a ArrowUp.png ...            %                 "              
    -a OpenFile.png -a Chelon.png -a Arrow_LaunchFigure.jpg...                        %                 "              
    -m ChelomEx_Menu.m ChelomEx_pattern_figure.m ChelomEx_peak_figure.m ...           % GUIs
       ChelomEx_open_run_menu.m ChelomEx_qdlg.m ChelomEx_pattern_definition.m...      %  "
       ChelomEx_pattern_definition_isotopes.m ChelomEx_id_database.m...               %  "
       ChelomEx_search_manual.m ChelomEx_parameters_filters.m...                      %  "
       search_Pattern.m find_pattern.m group_pattern.m ptrn2pk_species.m ptrn2pk.m... % in ChelomEx_Menu
       search_species.m save_results.m...                                             %         "
       plot_pattern.m plotms.m...                                                     % in ChelomEx_pattern_figure
       mzxmlimport.m mzxmlread.m...                                                   % in ChelomEx_open_run_menu
       eic.m existMSMS.m vcompare.m totalionc.m findPeaks.m...                        % in multiple functions
       findapoMS2.m sort_results_pks.m FindSpecies.m...                               %            "
       get_db_species.m dbcompare_pks.m...                                            %            "
       datacursorfcn.m hsl2rgb.m rgb2hsl.m existMSMS.m                                %            "
      
