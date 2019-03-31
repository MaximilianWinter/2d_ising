function energy = totenergy(spins, B)
J = 1;
J_prime = 1;
mu = 1;
E_0 = -B*mu;

A = spins.*circshift(spins,1,2);
B = spins.*circshift(spins,1,1);

energy = E_0.*sum(spins(:)) - J.*sum(A(:)) - J_prime.*sum(B(:));
end