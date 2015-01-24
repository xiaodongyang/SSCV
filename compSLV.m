function compSLV(info)

% load visual descriptor words
basisFileName = [info.type, '_Basis_', num2str(info.ncenter), '.mat'];
load(basisFileName, 'basis');

% load visual location words
stbasisFileName = [info.type, '_STBasis_', num2str(info.ncenter), '_', num2str(info.nstcenter), '.mat'];
load(stbasisFileName, 'stbasis');

% remove NaN elements
flag = isnan(stbasis);
stbasis(flag) = 0;

% do the job
for i = 1:length(info.cls)
    for j = 1:info.ngroup
        idxGroup = sprintf('%02d', j);
        
        k = 1;
        while 1
            idxVid = sprintf('%02d', k);
            disp(['assigning class: ', info.cls{i}, ', group: ', idxGroup, ...
                  ', video: ', idxVid, ' ......']);
              
            featFileName = [info.dirfeat, '\', info.type, '\', info.cls{i}, ...
                            '\v_', info.cls{i}, '_', idxGroup, '_', idxVid, info.suffix];
                        
            if ~exist(featFileName, 'file')
                break;
            end
            
            vecFileName = [info.dirvec, '\', info.type, '\', info.cls{i}, ...
                           '\v_', info.cls{i}, '_', idxGroup, '_', idxVid, '.mat'];
            
            if exist(vecFileName, 'file')
                k = k + 1;
                continue;
            end
            
            % read features and keys
            [keys, feats] = readSingleFileSTIP(featFileName);

            if isempty(feats)
                slv = zeros(1, numel(stbasis));
                save(vecFileName, 'slv');
                k = k + 1;
                continue;
            end
            
            % whitening descriptors
            feats = feats';
            feats = feats - repmat(mean(feats), size(feats, 1), 1);
            feats = feats ./ repmat(sqrt(sum(feats.^2)), size(feats, 1), 1);
            feats = feats';  
            
            % coding low-level features
            codes = codingFeats(info, basis, feats);
            
            % read frame info
            frmFileName = [info.dirfrm, '\', info.cls{i}, '\v_', info.cls{i}, '_', idxGroup, '_', idxVid];
            frm = readFrameInfo(frmFileName);

            % normalize keys
            keys(:, 1) = keys(:, 1) / frm.ncol;
            keys(:, 2) = keys(:, 2) / frm.nrow;
            keys(:, 3) = keys(:, 3) / frm.nfrm;
            
            % coding and pooling keys
            slv = getCodingPoolingKeys(info, stbasis, keys, codes);
            save(vecFileName, 'slv');
        end
    end
end

end