function [energies, magnetization] = magnetization(H, T)
%this function calculates the magnetization of the spin array as a function
%of the applied mag field and temperature

gridsize = 50;
N = gridsize^2; %size of simulated array

magnetization_list = [];

n = 10;

Tcrit = 3;


[spins, energy] = ising2d(H, T, Tcrit);
magnetization_list = [sum(sum(spins))/N];
for counter = 1:n-1
    %find the number of spins pointing up and down
    %[numbers, edges] = histcounts(spins, 2);
    %number_down = numbers(1);
    %number_up = numbers(2);
    [spins, newenergy] = ising2d(H, T, Tcrit);
    magnetization_list(end + 1) = sum(sum(spins))/N;
    energy = energy + newenergy;
end

magnetization = mean(abs(magnetization_list))
energies = energy;
end