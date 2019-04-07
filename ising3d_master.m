avg_n = 1;
T = 0.1:0.2:6.5;
%T = 0.1:2:5;
B = 1.0;
T_ic = 5;
gridsize = 10;
J = 1;
J_prime = 1;
J_pprime = 1;
plots = true;



magnetization_arr = zeros(1, avg_n);
mean_magnetizations = zeros(1, length(T));

for t = T
    for i = 1:avg_n
        [magnetization_arr(i), spins, energy] = ising3d(B, t, T_ic, gridsize, J, J_prime,J_pprime,plots);
    end
    index = find(t==T);
    mean_magnetizations(index) = mean(abs(magnetization_arr))
end




%%%FITTING%%%
guess_paras = [1,2.5,1/8,1];
paras = lsqcurvefit(@M_theo, guess_paras,T,mean_magnetizations);


%%%PLOTTING OF M(T) vs T incl. FIT%%%
f = figure(1);
grid on
Tc = paras(2);
Tnew = 0.1:0.01:Tc;
plot(Tnew,M_theo(paras,Tnew))
hold on
scatter(T,mean_magnetizations);
hold off
xlabel('T in J/k_B');
ylabel('(normalized, averaged) magnetization M');
dim = [.2 .2 .3 .3];
str = {'M(0) = ' + string(paras(1)),'T_c = ' + string(paras(2)), '\alpha = ' + string(paras(3)), '\beta = ' + string(paras(4))};
annotation('textbox',dim,'String',str,'FitBoxToText','on');
titlestring = 'n = ' + string(avg_n) + ', B = ' + string(B) + ', J = ' + string(J) + ', J´ = ' + string(J_prime) +', J´´ = ' + string(J_pprime) + ', N = ' + string(gridsize);
title(titlestring);
filestring = 'magnetization_n_' +string(avg_n) + '_B_' + string(B) + '_J_' + string(J) + '_Jp_' + string(J_prime) + '_Jpp_' + string(J_pprime) + '_N_' + string(gridsize) + '.png';
saveas(f, filestring);
grid off



%%%save as txt%%%
fo = fopen(filestring + '.txt','w');
fprintf(fo, '%f %f \r\n', mean_magnetizations, T);
fclose(fo);
function M_theoval = M_theo(paras, T)
alpha = paras(3);
beta = paras(4);
M_theoval = real(paras(1).*(1-(T./paras(2)).^alpha).^beta);
end