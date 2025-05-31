function images = loadMNISTImages(filename)
%loadMNISTImages returns a 28x28x[number of MNIST images] matrix containing
%the raw MNIST images 导入MNISTImages，然后返回一个28*28*[number of MNIST
%images]的矩阵，其中包含有原始的MNIST影像。

fp = fopen(filename, 'rb');%打开二进制影像，保存在fp中
assert(fp ~= -1, ['Could not open ', filename, '']);%在违反条件时将会生成一个错误，即打不开该影像。

magic = fread(fp, 1, 'int32', 0, 'ieee-be'); %从fp中读入二进制影像，读入的大小为1，其中数据类型为int32
assert(magic == 2051, ['Bad magic number in ', filename, '']);

numImages = fread(fp, 1, 'int32', 0, 'ieee-be');%ieee-be是高位优先，最重要的字节先存储；ieee-le是低位优先，不重要的字节先存储，影像的个数
numRows = fread(fp, 1, 'int32', 0, 'ieee-be');%获取的是影像中像素的行数
numCols = fread(fp, 1, 'int32', 0, 'ieee-be');%获取的是影像中像素的列数

images = fread(fp, inf, 'unsigned char');%以umsigned char的格式从开头读到文件尾，读入原始影像
images = reshape(images, numRows, numCols, numImages);%将原始影像的大小转换为numCols行，numRows列，numImages个影像
images = permute(images,[2 1 3]);%将影像images按[2 1 3]这样的维数进行排列，即按numRows行，numCols列，numImages个影像

fclose(fp);

% Reshape to #pixels x #examples
images = reshape(images, size(images, 1) * size(images, 2), size(images, 3));%将原始影像images转换为numRows行，numCols列，numImages个影像
% Convert to double and rescale to [0,1] 将影像转换为double型的，并且将其归一化在[0 1]
images = double(images) / 255;

end
