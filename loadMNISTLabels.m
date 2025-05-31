function labels = loadMNISTLabels(filename)
%loadMNISTLabels returns a [number of MNIST images]x1 matrix containing
%the labels for the MNIST images

fp = fopen(filename, 'rb');
assert(fp ~= -1, ['Could not open ', filename, '']);

magic = fread(fp, 1, 'int32', 0, 'ieee-be');
assert(magic == 2049, ['Bad magic number in ', filename, '']);

numLabels = fread(fp, 1, 'int32', 0, 'ieee-be');%读入的是label的总行数

labels = fread(fp, inf, 'unsigned char');%labels是一个关于label的二维矩阵，其中该矩阵的行数为numLabels

assert(size(labels,1) == numLabels, 'Mismatch in label count');

fclose(fp);

end
