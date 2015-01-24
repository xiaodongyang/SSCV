function compSLVBasis(info)

% load visual descriptor words
basisFileName = [info.type, '_Basis_', num2str(info.ncenter), '.mat'];
load(basisFileName, 'basis');

% spatio-temporal locations associated with visual descriptor words
nlarge = 1E+6;
stloc = cell(info.ncenter, 1);
srow = ones(1, info.ncenter);
erow = zeros(1, info.ncenter);

for i = 1:info.ncenter
    stloc{i} = zeros(nlarge, 3);
end

% assign keys to visual words
for i = 1:length(info.cls)
    for j = 1:info.ngroup
        idxGroup = sprintf('%02d', j);
        
        k = 1;
        while 1
            idxVid = sprintf('%02d', k);
            disp(['assigning class: ', info.cls{i}, ', group: ', idxGroup, ...
                  ', video: ', idxVid, ' ......']);
            
            featFileName = [info.dirfeat, '\', info.type, '\', info.cls{i}, ...
                            '\v_', info.cls{i}, '_', idxGroup, '_', idxVid, info.sufix];
                        
            if ~exist(featFileName, 'file')
                break;
            end
            
            % read features
            [keys, feats] = readSingleFileSTIP(featFileName);

            if isempty(feats)
                k = k + 1;
                continue;
            end
            
            idx = randperm(size(keys, 1));
            idx = idx(1:round(length(idx) / 3));
            
            keys = keys(idx, :);
            feats = feats(idx, :);

            % read frame info
            frmFileName = [info.dirfrm, '\', info.cls{i}, '\v_', info.cls{i}, '_', idxGroup, '_', idxVid];
            frm = readFrameInfo(frmFileName);

            % normalize keys
            keys(:, 1) = keys(:, 1) / frm.ncol;
            keys(:, 2) = keys(:, 2) / frm.nrow;
            keys(:, 3) = keys(:, 3) / frm.nfrm;
            
            % whitening descriptors
            feats = feats';
            feats = feats - repmat(mean(feats), size(feats, 1), 1);
            feats = feats ./ repmat(sqrt(sum(feats.^2)), size(feats, 1), 1);
            feats = feats';
            
            % coding low-level features
            codes = codingFeats(basis, feats);
            
            % associate keys with each visual word
            idx = codes > 0;

            for t = 1:info.ncenter
                % number of features having non-zero weights to the t-th visual descriptor world
                nt = sum(idx(:, t));
                if nt == 0
                    continue;
                end

                erow(t) = erow(t) + nt;            
                stloc{t}(srow(t):erow(t), :) = keys(idx(:, t), :);
                srow(t) = erow(t) + 1;
                
                if srow(t) > nlarge
                    disp(['warning overflow at center: ', num2str(t), ' !!!!']);
                end
            end
            
            k = k + 1; 
        end
    end
end

% remove empty rows
for i = 1:info.ncenter
    stloc{i}(srow(i):end, :) = [];
end

% compute visual location words for each visual descriptor word
stbasis = zeros(3, info.nstcenter, info.ncenter);

param.lambda = 0.01;
param.K = info.nstcenter;
param.iter = 1000;

for i = 1:info.ncenter
    disp(['computing visual location words for visual descriptor word: ', num2str(i), ' ......']);
    buff = stloc{i};
    
    if size(buff, 1) < 50
        stbasis(:, :, i) = zeros(3, info.nstcenter);
        continue;
    end
    
    % normalization
    buff = buff';
    buff = buff - repmat(mean(buff), size(buff, 1), 1); 
    buff = buff ./ repmat(sqrt(sum(buff.^2)), size(buff, 1), 1);

    rtn = mexTrainDL_Memory(buff, param); % each column corresponds to a visual word
    stbasis(:, :, i) = rtn;
end

stbasisFileName = [info.type, '_STBasis_', num2str(info.ncenter), '_', num2str(info.nstcenter), '.mat'];
save(stbasisFileName, 'stbasis');

end