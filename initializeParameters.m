function theta = initializeParameters(hiddenSize, visibleSize) %�����ĳ�ʼ����СΪ���ص�Ԫ��СhiddenSize�Ϳɼ���Ԫ��СvisibleSize

%% Initialize parameters randomly based on layer sizes.����ÿ��Ĵ�С�����ʼ������
r  = sqrt(6) / sqrt(hiddenSize+visibleSize+1);   % we'll choose weights uniformly from the interval [-r, r] ����һ�ɴ�[-r,r]��ѡ��Ȩ�ش�С
W1 = rand(hiddenSize, visibleSize) * 2 * r - r;  %W1�Ĵ�СΪhiddenSize�У�visibleSize�У��������ʼ������hiddenSize��visibleSize�еĻ����ϣ��ֱ����2*r,Ȼ�������ڼ�ȥr
W2 = rand(visibleSize, hiddenSize) * 2 * r - r;  %W2�Ĵ�СΪvisibleSize�У�hiddenSize��

b1 = zeros(hiddenSize, 1); %b1�Ĵ�СΪhiddenSize��1��
b2 = zeros(visibleSize, 1); %b2�Ĵ�СΪvisibleSize��1��

% Convert weights and bias gradients to the vector form. ��Ȩ�غ�ƫ���ݶ�ת��Ϊʸ����ʽ
% This step will "unroll" (flatten and concatenate together) all
% ��һ�����Ὣ���еĲ���չ��Ϊһ��ʸ����չ�����̰���ƽ����������һ�𣩣�Ȼ���ʸ�����Ա��õ�minFunc�У����Ǿ������ô���أ���
% your parameters into a vector, which can then be used with minFunc. 
theta = [W1(:) ; W2(:) ; b1(:) ; b2(:)];

end
