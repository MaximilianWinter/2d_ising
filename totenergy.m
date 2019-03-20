function energy = totenergy(spins)
J = 1;
J_prime = 1;
E_0 = -0.1;

A = spins.*circshift(spins,1,2);
B = spins.*circshift(spins,1,1);

energy = E_0.*sum(spins(:)) - J.*sum(A(:)) - J_prime.*sum(B(:));
end