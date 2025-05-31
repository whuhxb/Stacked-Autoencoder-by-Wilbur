function images = loadMNISTImages(filename)
%loadMNISTImages returns a 28x28x[number of MNIST images] matrix containing
%the raw MNIST images ����MNISTImages��Ȼ�󷵻�һ��28*28*[number of MNIST
%images]�ľ������а�����ԭʼ��MNISTӰ��

fp = fopen(filename, 'rb');%�򿪶�����Ӱ�񣬱�����fp��
assert(fp ~= -1, ['Could not open ', filename, '']);%��Υ������ʱ��������һ�����󣬼��򲻿���Ӱ��

magic = fread(fp, 1, 'int32', 0, 'ieee-be'); %��fp�ж��������Ӱ�񣬶���Ĵ�СΪ1��������������Ϊint32
assert(magic == 2051, ['Bad magic number in ', filename, '']);

numImages = fread(fp, 1, 'int32', 0, 'ieee-be');%ieee-be�Ǹ�λ���ȣ�����Ҫ���ֽ��ȴ洢��ieee-le�ǵ�λ���ȣ�����Ҫ���ֽ��ȴ洢��Ӱ��ĸ���
numRows = fread(fp, 1, 'int32', 0, 'ieee-be');%��ȡ����Ӱ�������ص�����
numCols = fread(fp, 1, 'int32', 0, 'ieee-be');%��ȡ����Ӱ�������ص�����

images = fread(fp, inf, 'unsigned char');%��umsigned char�ĸ�ʽ�ӿ�ͷ�����ļ�β������ԭʼӰ��
images = reshape(images, numRows, numCols, numImages);%��ԭʼӰ��Ĵ�Сת��ΪnumCols�У�numRows�У�numImages��Ӱ��
images = permute(images,[2 1 3]);%��Ӱ��images��[2 1 3]������ά���������У�����numRows�У�numCols�У�numImages��Ӱ��

fclose(fp);

% Reshape to #pixels x #examples
images = reshape(images, size(images, 1) * size(images, 2), size(images, 3));%��ԭʼӰ��imagesת��ΪnumRows�У�numCols�У�numImages��Ӱ��
% Convert to double and rescale to [0,1] ��Ӱ��ת��Ϊdouble�͵ģ����ҽ����һ����[0 1]
images = double(images) / 255;

end
