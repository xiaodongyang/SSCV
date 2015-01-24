function compSDVBasis(info)

% read low-level features
disp('reading STIP features ......');
feats = readFeatSTIP(info);
disp(['number of features: ', num2str(size(feats, 1))]);

% whitening
feats = feats';
feats = feats - repmat(mean(feats), size(feats, 1), 1);
feats = feats ./ repmat(sqrt(sum(feats.^2)), size(feats, 1), 1);

% compute visual descriptor words by sparse coding
param.iter = 1000;
param.K = info.ncenter;
param.lambda = 1.2 / sqrt(size(feats, 1));

basis = mexTrainDL_Memory(feats, param);

basisFileName = [info.type, '_Basis_', num2str(info.ncenter), '.mat'];
save(basisFileName, 'basis');

end