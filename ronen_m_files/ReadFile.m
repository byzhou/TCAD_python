%function y = ReadFile  ( fileName )
%fileName       -> Saved File Name
%% Read in Data

% Find out number of rows in file
r=0;
x=0;
% Open Data File
%fpref = '../HT_AES_DEF_ext/';
%fpref = 'txt/';

%fidy = fopen([fpref 'x300310y300310.txt'], 'rt');
%fileName    = 'HTInx1020y1020' ;
fNameSave   = strcat ( fileName , '.txt' ) ;
fidy        = fopen([fpref fNameSave], 'rt') ;
% Loop through data file until we get a -1 indicating EOF
while(x~=(-1))
          x=fgetl(fidy);
          r=r+1;
end
r = r-1;
disp(['Number of rows = ' num2str(r)])
frewind(fidy);

coords = zeros(r, 4);
str = cell(r,1);

for n = 1:r
    str{n} = fscanf(fidy, '%s', 1);
    ins{n} = fscanf(fidy, '%s', 1);
    temp = fscanf(fidy, '%f', 8);
    coords(n,:) = temp([1,2,5,6]).';
end

fclose(fidy);

% *** Find the unique cells *** %

ustr{1} = str{1};
Nu = 1;

for n = 2:length(str)
    isnew = 1;
    for m = 1:Nu
        if strcmp(str{n}, ustr{m})
            isnew = 0;
           break;
        end
    end
    if isnew
        Nu = Nu + 1;
        ustr{Nu} = str{n};
    end
end

save ( fileName ) ;
