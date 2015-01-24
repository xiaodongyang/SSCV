function codes = codingFeats(basis, feats)

% parameters
param.pos = 1;
param.lambda = 1.2 / sqrt(size(feats, 2));

% sparse coding by lasso
codes = mexLasso(feats', basis, param);
codes = full(codes)';

end