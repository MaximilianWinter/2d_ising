function [magnetization, S_f, energy] = ising3d(B, T, T_ic, gridsize, J, J_prime,J_pprime,plots)

%define constants
kB = 1;
beta = 1./(kB.*T);

%make quadratic lattice of gridsize; either with random spins (+-1) or all
%spins aligned
if T < T_ic
    s = ones(gridsize,gridsize,gridsize);
else
    s = randi([0,1], gridsize,gridsize,gridsize);
    s(s==0)=-1;
end


%%%CREATE COORDINATES%%%
x=0;
y=0;
z=0;
for i = 1:gridsize
    for j = 1:gridsize
        for k = 1:gridsize
            x(end+1) = i;
            y(end+1) = j;
            z(end+1) = k;
        end
    end
end
x=x(2:end);
y=y(2:end);
z=z(2:end);

scol = reshape(s,[1,gridsize^3]);

%%%PLOT OF INITIAL GRID%%%
if plots == true
    figure(1)
    scatter3(x,y,z,40,scol,'filled');
    title('B = ' + string(B) + ', T = ' + string(T));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%


S_i = s;
%%%DEFINE MAXIMUM STEPS%%%
steps = 1500000;
%%%%%%%%%%%%%%%%%%%%%%%%%%

energy_list = zeros(steps+1,1);
tot_spin_list = zeros(steps+1,1);
energy_list(1) = [totenergy(s,B, J, J_prime, J_pprime)];
for n = 1:steps 
    
    i = randi(gridsize,1);
    j = randi(gridsize,1);
    k = randi(gridsize,1);
    
    s(i,j,k) = -s(i,j,k);
    
    deltaE = totenergy(s,B, J, J_prime, J_pprime) - energy_list(n);
    if deltaE > 0
        if rand() < exp(-beta*deltaE)
            energy_list(n+1) = deltaE+energy_list(n);
        else
            s(i,j,k) = -s(i,j,k);
            energy_list(n+1) = energy_list(n);
        end
    else
        energy_list(n+1) = deltaE+energy_list(n);
    end
    
    tot_spin_list(n) = sum(sum(sum(s)))/gridsize^3;
    
%     if mod(n,1000) == 0
%         slope = abs((energy_list(n)-energy_list(n-999))/1000);
%         if slope < 1e-3
%             break;
%             %continue;
%         end
%     end
    %%CHECKS EVERY 1000 STEPS THE SLOPE%%%
    %%IF SMALL ENOUGH LOOP IS STOPPED%%%%%
    if mod(n,10100) == 0
        mean_energy_1 = mean(energy_list(n-100:n));
        mean_spin_1 = mean(tot_spin_list(n-100:n));
        
        m = n-9999;
        mean_energy_2 = mean(energy_list(m-100:m));
        mean_spin_2 = mean(tot_spin_list(m-100:m));
        energy_slope = abs((mean_energy_1 - mean_energy_2)/10000);
        spin_slope = abs((mean_spin_1 - mean_spin_2)/10000);
        if (energy_slope < 1e-3) && (spin_slope < 1e-3)
            disp('e_slope: ' + string(energy_slope) + ' s_slope: ' + string(spin_slope));
            disp('n: ' + string(n)); 
            break;
            %continue;
        end
    end
end


S_f = s;
energy = energy_list;
%%%normalized magnetization%%%
magnetization = abs(sum(sum(sum(S_f)))/gridsize^3);

%%%PLOT OF FINAL GRID%%%
if plots == true
    f = figure(2);
    scol = reshape(s,[1,gridsize^3]);
    scatter3(x,y,z,40,scol,'filled');
    titlestring = 'B = ' + string(B) + ', T = ' + string(T) + ', M = ' + string(magnetization);
    title(titlestring);
    filestring = 'B_' + string(B) + '_T_' + string(T)  + '_J_' + string(J) + '_Jp_' + string(J_prime) + '_N_' + string(gridsize) + '.png';
%     saveas(f, filestring);
end
%%%%%%%%%%%%%%%%%%%%%%%%


%%%CALCULATES THE TOTAL ENERGY%%%
function energy = totenergy(spins, B, J, J_prime, J_pprime)
mu = 1;
E_0 = (-1)*B*mu;

A = spins.*circshift(spins,1,2);
B = spins.*circshift(spins,1,1);
C = spins.*circshift(spins,1,3);

energy = E_0.*sum(spins(:)) - J.*sum(A(:)) - J_prime.*sum(B(:)) - J_pprime.*sum(C(:)) ;
end


end