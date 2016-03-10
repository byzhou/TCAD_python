
%% Generate GMAP Plot
%figure;
%pcolor(xlist, ylist, GMap);
%
%set(get(get(gcf,'Children'),'Children'),'LineStyle','none');
%a = gray(Nu);
%b = hsv(Nu);
%colormap([a(3:23,:); b(21:23,:)]);
%axis equal
%axis tight

%% Generate Reflectance Map
addpath ( 'cbxplot' ) 
load tmp;
figure;
pcolor(xlist, ylist, RMap);
caxis([0,1]);
set(get(get(gcf,'Children'),'Children'),'LineStyle','none');
%set(gca,'YTick',[ymin:ystep:ymax],'YLim',[ymin ymax]) ;
axis equal
axis tight
colorbar
%%save figure
saveas ( gcf , savePath , 'pdf' ) ;
savePath
!evince shi-pdf/TjInx2030y2030.pdf &


%% Generate Image Map
figure;
pcolor(xlist, ylist, IMMapN);
caxis([0,1]);
set(get(get(gcf,'Children'),'Children'),'LineStyle','none');
axis equal
axis tight
colorbar
%%save figure
saveas ( gcf , savePath , 'pdf' ) ;

