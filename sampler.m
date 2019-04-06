T = 0.1:0.2:5;
%T = 0.1;
%T = 0.1:0.6:4.5;
% T = [0.5,1.4,2.3,3.2,4.1];
%T = [2.35,2.40,2.50,2.55,2.65,2.70];
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


%%%FITTING%%%
paras = lsqcurvefit(@m_fun, real([1,2.5,3,1/2]),real(T),real(magnetization_list));

figure(3)
Tcrit = paras(2);
Tnew = 0.1:0.01:Tcrit;
plot(Tnew,m_fun(paras,Tnew))
hold on
scatter(T,magnetization_list);
hold off

function m_val = m_fun(paras, T)
alpha = paras(3);
beta = paras(4);
m_val = real(paras(1).*(1-(T./paras(2)).^alpha).^beta);
end