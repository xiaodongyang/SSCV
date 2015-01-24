function compSDV(info)

% load visual descriptor words
basisFileName = [info.type, '_Basis_', num2str(info.ncenter), '.mat'];
load(basisFileName, 'basis');

% do the job
for i = 1:length(info.cls)
    for j = 1:info.ngroup
        idxGroup = sprintf('%02d', j);
        disp(['computing class: ', info.cls{i}, ', group: ', idxGroup, ' ......']);
        
        k = 1;
        while 1
            idxVid = sprintf('%02d', k);
            featFileName = [info.dirfeat, '\', info.type, '\', info.cls{i}, ...
                            '\v_', info.cls{i}, '_', idxGroup, '_', idxVid, info.sufix];
  
            if ~exist(featFileName, 'file')
                break;
            end
            
            vecFileName = [info.dirvec, '\', info.type, '\', info.cls{i}, ...
                           '\v_', info.cls{i}, '_', idxGroup, '_', idxVid];
                       
            if exist([vecFileName, '.mat'], 'file')
                k = k + 1;
                continue;
            end
            
            % read low-level features
            [~, feats] = readSingleFileSTIP(featFileName);

            if isempty(feats)
                sdv = zeros(1, size(basis, 1) * size(basis, 2));
                save(vecFileName, 'sdv');
                continue;
            end
            
            % whitening
            feats = feats';
            feats = feats - repmat(mean(feats), size(feats, 1), 1);
            feats = feats ./ repmat(sqrt(sum(feats.^2)), size(feats, 1), 1);
            feats = feats';

            % coding
            codes = codingFeats(basis, feats);
            
            % pooling
            sdv = poolingFeats(basis, feats, codes);
            
            save(vecFileName, 'sdv');
            
            k = k + 1;
        end
    end
end

end