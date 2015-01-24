function codes = codingKeys(keys, stbasis)

% parameters
param.pos = 1;
param.lambda = 0.01;

% sparse coding by lasso
codes = mexLasso(keys', stbasis, param);
codes = full(codes)';

end