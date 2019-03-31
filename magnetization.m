function magnetization = magnetization(H, T)
%this function calculates the magnetization of the spin array as a function
%of the applied mag field and temperature
N = 100^2; %size of simulated array

 magnetization_list = [];

n = 5;

for counter = 1:n
    [spins, energy] = ising2d(H, T);

    %find the number of spins pointing up and down
    [numbers, edges] = histcounts(spins, 2);
    number_down = numbers(1);
    number_up = numbers(2);

    magnetization_list(end + 1) = (number_up - number_down)/N;
end

magnetization = mean(abs(magnetization_list))
end