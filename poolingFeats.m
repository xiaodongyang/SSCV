function sv = poolingFeats(basis, feats, codes)

% pooling the low-level features 
basis = basis';
ncenter = size(basis, 1);
[nfeat, ndim] = size(feats);

sv = zeros(1, ncenter * ndim);

for i = 1:ncenter
    imean = feats - repmat(basis(i, :), nfeat, 1);
    imean = imean .* repmat(codes(:, i), 1, ndim);
    
    if nfeat > 1
        imean = sum(imean) / nfeat;
    end
    
    s = ndim * (i - 1) + 1;
    e = ndim * i;
    sv(s:e) = imean;   
end

% power normalization
idx = sv > 0;
sv(idx) = sqrt(sv(idx));
idx = sv < 0;
sv(idx) = -sqrt(-sv(idx));

% L2 normalization
norm = sqrt(sum(sv.^2));
sv = sv / norm;

end