function deltaM = get_db_species(type)
% Creates a structure with delta masses and IDs to find related species 

% input: 
% type = string, 'adducts' or 'derivatives' describes the type of species to return

% output:
% deltaM = structure with fields
%   id = string descriptions of the calculated mass difference
%   dm = vector with mass differences


m{1} = [1.00783; 12; 14.00307; 15.99491; 22.989769];
m{2} = {'H';'C';'N'; 'O';'Na'};


% Matrix with species: combination of above masses, in rows is the
% number of 'H';'C';'N'; 'O';'Na'

switch type
    case 'adducts'
        M = [-1	0	0	0	1
            -2	0	0	0	2
            -3	0	0	0	3
            3	0	1	0	0
            6	0	2	0	0
            -1	0	0	0	0
            1	0	0	0	0
            2	1	0	2	0
            1	1	0	2	1
            4	2	0	2	0
            3	2	0	2	1
            3	2	1	0	0
            ]; %for Matrix selection: see excel file "MassLists.xls"

    case 'derivatives'

        M =[-2	0	0	0	0
            2	0	0	0	0
            2	0	0	-1	0
            -2	0	0	1	0
            0	0	0	1	0
            0	0	0	-1	0
            -2	0	0	-1	0
            2	0	0	1	0
            -2	-1	0	0	0
            -4	-2	0	0	0
            2	1	0	0	0
            4	2	0	0	0
            2	1	0	2	0
            1	1	0	2	1
            4	2	0	2	0
            3	2	0	2	1
            3	2	1	0	0
            ];
end
       
        
deltaM.id = cell(length(M(:,1)),1);

for i=1:length(M(:,1))
    deltaM.dm(i) = sum(M(i,:) .* m{1}(:)');
    nonzero = find(M(i,:) ~= 0);
    for j = 1:length(nonzero)
        if abs(M(i,nonzero(j))) > 1
            natoms = sprintf('%+0i', M(i,nonzero(j)));
        elseif M(i,nonzero(j)) == 1
            natoms = '+';
        elseif M(i,nonzero(j)) == -1
            natoms = '-';
        end
        deltaM.id{i} = [deltaM.id{i},' ',natoms,m{2}{nonzero(j)}];
    end
   
end

end
