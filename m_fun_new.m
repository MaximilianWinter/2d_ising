function m_val = m_fun_new(paras, T)
alpha = paras(3);
beta = paras(4);
m_val = real(paras(1).*(1-(T./paras(2)).^alpha).^beta);
end