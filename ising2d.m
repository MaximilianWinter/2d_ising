function [S_f, energy] = ising2d(B, T)

%define constants
kB = 1;
%T = 3;
beta = 1/(kB*T);

%make 100x100 lattice with random spins (+-1)
s = randi([0,1],100);
s(s==0)=-1;
figure(1)
h=pcolor(s);
title('B = ' + string(B) + ', T = ' + string(T));

S_i = s;
energy_list = [totenergy(s,B)];
for n = 1:150000 %think about this condition
    
    i = randi(100,1);
    j = randi(100,1);
    
    s(i,j) = -s(i,j);
    
    deltaE = totenergy(s,B) - energy_list(end);
    
    if rand() < exp(-beta*deltaE)
        energy_list(end+1) = deltaE+energy_list(end);
    else
        s(i,j) = -s(i,j);
        energy_list(end+1) = energy_list(end);
    end
    
%     h=pcolor(s);
    %Frames(n) = getframe(gca);
end
figure(2)
steps=1:(n+1);
plot(steps,energy_list);
title('B = ' + string(B) + ', T = ' + string(T));
figure(3)
h=pcolor(s);
title('B = ' + string(B) + ', T = ' + string(T));
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