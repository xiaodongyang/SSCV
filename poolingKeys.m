function vec = poolingKeys(keys, stbasis, codes, weights)

stbasis = stbasis';
nkey = size(keys, 1);
ncenter = size(stbasis, 1);

vec = zeros(1, 3 * ncenter);

for i = 1:ncenter
    imean = keys - repmat(stbasis(i, :), nkey, 1);
    imean = imean .* repmat(codes(:, i), 1, 3);
    imean = imean .* repmat(weights, 1, 3);
    
    if nkey > 1
        imean = sum(imean) / nkey;
    end
    
    s = 3 * (i - 1) + 1;
    e = 3 * i;
    vec(s:e) = imean;
end

end