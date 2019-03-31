T = 0.1:0.3:4;

B = 0.0;

magnetization_list = [];
for t = T
    for b = B
        magnetization_list(end+1) = magnetization(b,t);
    end
end
        
scatter(T,magnetization_list);
xlabel('T');
ylabel('M');