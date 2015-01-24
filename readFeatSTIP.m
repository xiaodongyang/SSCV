function feats = readFeatSTIP(info)

ndim = 162;
nfeat = 1E+6;
feats = zeros(nfeat, ndim);

idx = 1;
ncls = length(info.cls);

for i = 1:ncls
    disp(['from class: ', info.cls{i}, ' ...']);
    
    for j = 1:info.ngroup
        k = 1;
        idxGroup = sprintf('%02d', j);
        
        while 1
            idxVid = sprintf('%02d', k);
            featFileName = [info.dirfeat, '\', info.type, '\', info.cls{i}, ...
                            '\v_', info.cls{i}, '_', idxGroup, '_', idxVid];
            
            fp = fopen(featFileName, 'r');
            if fp < 0
                break;
            end
            
            count = 1;
            
            % read header
            fgetl(fp); fgetl(fp); fgetl(fp);

            % read feature
            while ~isempty(fscanf(fp, '%d', 1))
                % read detector
                fscanf(fp, '%d', 5);
                fscanf(fp, '%f', 1);

                % read descriptor and fill in
                if mod(count, info.rate) == 1
                    feats(idx, :) = fscanf(fp, '%f', ndim);
                    idx = idx + 1;
                else
                    fscanf(fp, '%f', ndim);
                end

                count = count + 1;
            end

            fclose(fp);
            k = k + 1;
        end
    end
end

% remove empty rows
feats(idx:end, :) = [];

end