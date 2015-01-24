function vec = getCodingPoolingKeys(info, stbasis, keys, codes)

vec = zeros(1, prod(size(stbasis)));
stride = size(stbasis, 1) * size(stbasis, 2);

idx = codes > 0;

for i = 1:info.ncenter
    % features assigned to the i-th visual descriptor word
    ni = sum(idx(:, i));
    if ni == 0
        continue;
    end
    
    % coding by the visual location words associated with the i-th visual descriptor word
    icodes = codingKeys(keys(idx(:, i), :), stbasis(:, :, i));
    
    % weighted pooling
    ivec = poolingKeys(keys(idx(:, i), :), stbasis(:, :, i), icodes, codes(idx(:, i), i));

    % fill in
    s = stride * (i - 1) + 1;
    e = stride * i;
    vec(s:e) = ivec;
end

% power normalization
pos = vec > 0;
vec(pos) = sqrt(vec(pos));
neg = vec < 0;
vec(neg) = -sqrt(-vec(neg));

% L2 normalization
norm = sqrt(sum(vec.^2));
if norm > 0
    vec = vec / norm;
end

end