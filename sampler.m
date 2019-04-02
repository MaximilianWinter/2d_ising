T = 0.1:0.2:5;

B = 0.0;

magnetization_list = [];
energy_list = {};
for t = T
    for b = B
        [energy_list{end+1}, magnetization_list(end+1)] = magnetization(b,t);
    end
end

figure(1)
scatter(T,magnetization_list);
xlabel('T');
ylabel('M');

figure(2)
plotnumber = length(energy_list);
hold on
for i = 1:plotnumber
    energy = energy_list(i);
    %subplot(plotnumber/2,2,i);
    
    plot(1:length(energy{1}),energy{1});
end
hold off