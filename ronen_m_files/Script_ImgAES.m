%function y = Script_ImgAES ( fileName ) 
% Script_ImgAES.m
%
% Script generates the reflectance image of the AES circuit using a
% paraxial approximation.

%dat_name = 'aes_x300310y300310.mat';
%fileName        = 'HTInx1020y1020' ;
dNameSaved      = strcat ( fileName , '.mat' ) ;
dat_name        = dNameSaved ;
lk_name         = 'aesLook_v3' ;

lam_val         = 1.0;
pol             = 2;

mis             = 0;
min_val         = ((3.5 - 1.45)/(3.5 + 1.45))^2;

xstep           = 0.1 ;
ystep           = 0.1 ;
epsilon         = 0.00001 ;

M               = 50;
NA              = 0.6;

% *** Load data *** %
load(dat_name);
lk = load(lk_name);

% *** Generate the reflectance value lookup table *** %

rf_vals = zeros(1, length(str));

% find the index of the specified wavelength
[er, idx] = min(abs(lk.lam - lam_val));

for n = 1:length(str)
    if ~isfield(lk, str{n})
        %bullshit    = floor ( length(str) * rand() ) ;
        %rf_vals(n)  = lk.(str{bullshit}).Rf(idx,pol);
        %rf_vals(n)  = rand() ;
        %rf_vals(n)  = 1 ;
        rf_vals(n)  = mis ;
    else
        rf_vals(n)  = lk.(str{n}).Rf(idx,pol);
        %rf_vals(n)  = 1;
    end
end

% *** Generate color coded picture of the circuit section *** %

% Get bounds
xmin = min(coords(:,1));
xmax = max(coords(:,3));
ymin = min(coords(:,4));
ymax = max(coords(:,2));

% setup mesh
xlist = xmin:xstep:xmax;
ylist = ymin:ystep:ymax;

[X,Y] = meshgrid(xlist, ylist);

% setup the list for the gates
for n = 1:Nu
    gids.(ustr{n}) = n;
end

GMap = zeros(size(X));
% for each gate, set the mesh values that are inside to the appropriate
% numerical value
i   = 0 ;
for n = 1:length(str)
   GMap ( ( X >= ( coords ( n , 1 ) ) ) ...
        & ( X <= coords ( n , 3 ) ) ...
        & ( Y <= ( coords ( n , 2 ) ) ) ...
        & ( Y >= coords ( n , 4 ) ) )...
        = gids.(str{n});
end

% *** Generate reflectance image of circit section *** %

RMap = min_val*ones(size(X));

for n = 1:length(str)
    RMap ( ( X >= ( coords ( n , 1 ) ...
            ...%+ epsilon ...
            ) ) ...
            & ( X <= ( coords ( n , 3 ) ...
            - epsilon ) ) ...
            & ( Y <= ( coords ( n , 2 ) ...
            - epsilon ) ) ...
            & ( Y >= ( coords ( n , 4 ) ...
            ...%+ epsilon ...
            ) ) ) ...
        = rf_vals(n);
end

% *** Generate image of the circuit section *** %

U = X*M;
V = Y*M;
ulist = xlist*M;
vlist = ylist*M;

uctr = (xmax + xmin)*M/2;
vctr = (ymax + ymin)*M/2;

P = sqrt((U - uctr).^2 + (V - vctr).^2);

Pp = NA*P/(M*lam_val);

psf = (besselj(1,2*pi*Pp)./(2*pi*Pp)).^2;

% *** Generate Image & Normalize it *** %

IMMap = conv2(psf,RMap, 'same');
temp = ones(size(U));
Norm = conv2(psf, temp, 'same');
nval = max(max(Norm));
IMMapN = IMMap/nval;

save tmp;
Plots;
