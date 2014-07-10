function [dbhits] = dbcompare_pks(foundmz, foundz, polarity, adducts, derivatives, offerr, relerr, minerr)
% compares found or calculated ligand m/z values with siderophore database
% m/z values (including adducts or derivatives of the database species)

% input
% foundmz and foundz = experimentally found species m/z and z values
% polarity = string that represent ion polarity mode, can be 'Positive' or 'Negative'
% adducts = field with adducts.dm = delta m values between adduct and
%    parent; adduts.id = cell array with string descriptions of adducts
% derivatives = field as for adducts
% offerr = mass error offset
% relerr = relative mass error in ppm
% minerr = minimum mass error in amu
  
% results
% dbhits is a structure with fields
% header = description of columns in dbhits.table
% table = cell array with results from database search

load('database.mat','database');  %SideroList is the siderophore database - a cell array with the M+Fe(III)-2H+ masses in column 1 and strings with IDs in column 2. This database can be generated from the excel sheet using the procedure "SideroImport".

% Calculate different derivatives, each derivative is treated as separate
% entry in the siderophore database
if ~isempty(derivatives.dm)
    dbder.data = zeros(size(database.data,1)*(1+length(derivatives.dm)), size(database.data,2));
    dbder.ID = cell(size(database.data,1)*(1+length(derivatives.dm)),1);
    dbder.derID = cell(size(database.data,1)*(1+length(derivatives.dm)),1);
    n=0;
    for i = 1:size(database.data,1) 
        n=n+1;
        dbder.data(n,:) = database.data(i,:);
        dbder.ID{n} = database.ID{i};
        dbder.derID{n} = {'none'};
        for j = 1:length(derivatives.dm)
            n=n+1;
            dbder.data(n,:) = [database.data(i,1)+derivatives.dm(j) database.data(i,2:6)];
            dbder.ID{n} = database.ID{i}; 
            dbder.derID{n} = derivatives.id{j};
        end
    end
else
    dbder = database;
    dbder.derID = repmat({'none'},size(dbder.data,1),1);
end


%% 1) apo database: get selected adduct species and derivatives, dimers and trimers
m.Hp = 1.00728; %mass proton 
m.Fe2 = 55.93384;            %mass iron(II)
m.Fe3 = 55.9333;            %mass iron(III)
m.Nap = 22.98922;            %mass Na+
m.H = 1.00783; %mass hydrogen
m.Fe = 55.93494; %mass iron

if strcmp(polarity, 'Positive')
    foundm = foundmz*foundz - m.Hp * foundz; 
elseif strcmp(polarity, 'Negative')
    foundm = foundmz*foundz + m.Hp * foundz; 
end
err = offerr + max(relerr*foundmz*10^-6, minerr);

dbhits.header = {'ID' 'Derivative' 'Adduct' 'neutral mass' 'delta m'}; 



% IDs for the modifications
adduct_id{1} = 'Monomer'; adduct_id{2} = 'Dimer'; adduct_id{3} = 'Trimer';
for j = 1:length(adduct_id)
    for m = 1:length(adducts.dm)
        adduct_id{length(adduct_id)+1} = [adduct_id{j} adducts.id{m}];
    end
end

db_hits = cell(0);
found = 0;
for i = 1:size(dbder.data,1)        %for each entry in the database
      db_m = [];
      %masses of the modifications
      db_m(1) = dbder.data(i,1);  %monomer 
      db_m(2) = db_m(1)*2;  %dimer
      db_m(3) = db_m(1)*3;  %trimer
      num_additionalspecies = length(db_m);
      for j = 1:num_additionalspecies
          db_m(length(db_m)+1:length(db_m)+length(adducts.dm)) =...
                                         db_m(j) + adducts.dm; %other species
      end
  

%% 2) Calculate neutral apo masses and compare with list of database masses
 
    for k = length(db_m):-1:1  %compare found m value to each mass in db_m    
        if foundm/foundz <= (db_m(k)/foundz + err) && foundm/foundz >= (db_m(k)/foundz - err)
            found = found+1;
            db_hits(found,:) = [dbder.ID{i} dbder.derID{i} adduct_id(k) db_m(k) (db_m(k)-foundm)/foundz];                    
        end
    end
    

end

if ~isempty(db_hits)
    db_hits = [db_hits num2cell(abs(cell2mat(db_hits(:,5))))];
    db_hits = sortrows(db_hits,6);
    dbhits.table = db_hits(:,1:5);
else
    dbhits.table = db_hits;
end

end



    
    