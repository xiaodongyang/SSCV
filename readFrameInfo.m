function frm = readFrameInfo(file)

fp = fopen(file, 'r');

fgetl(fp);
frm.nrow = fscanf(fp, '%d', 1);
frm.ncol = fscanf(fp, '%d', 1);
frm.nfrm = fscanf(fp, '%d', 1);

fclose(fp);

end