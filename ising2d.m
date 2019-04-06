function [S_f, energy] = ising2d(B, T, Tcrit)

%define constants
kB = 1;
beta = 1/(kB*T);

%make quadratic lattice of gridsize; either with random spins (+-1) or all
%spins aligned
gridsize = 50;
if T < Tcrit
    s = ones(gridsize);
else
    s = randi([0,1], gridsize);
    s(s==0)=-1;
end



figure(4)
h=pcolor(s);
title('B = ' + string(B) + ', T = ' + string(T));




S_i = s;
steps = 1500000;
energy_list = zeros(steps+1,1);
energy_list(1) = [totenergy(s,B)];
for n = 1:steps %think about this condition
    
    i = randi(gridsize,1);
    j = randi(gridsize,1);
    
    s(i,j) = -s(i,j);
    
    deltaE = totenergy(s,B) - energy_list(n);
    
    if rand() < exp(-beta*deltaE)
        energy_list(n+1) = deltaE+energy_list(n);
    else
        s(i,j) = -s(i,j);
        energy_list(n+1) = energy_list(n);
    end
    
%     h=pcolor(s);
    %Frames(n) = getframe(gca);
    if mod(n,1000) == 0
        slope = abs((energy_list(n)-energy_list(n-999))/200);
        if slope < 1e-3
            break;
            %continue;
        end
    end
end

%PLOTTING
% figure(2)
%steps=1:(n+1);
%plot(steps,energy_list);
%title('B = ' + string(B) + ', T = ' + string(T));
f = figure(5);
h=pcolor(s);
titlestring = 'B = ' + string(B) + ', T = ' + string(T);
title(titlestring);
%saveas(f, titlestring + '.png');
S_f = s;
energy = energy_list;




%fig = figure;
%movie(fig,Frames,2)

% vidObj = VideoWriter('vidtest.avi');
% vidObj.Quality = 90;
% vidObj.FrameRate = 20;
% open(vidObj);
% writeVideo(vidObj, Frames);
% close(vidObj);
end