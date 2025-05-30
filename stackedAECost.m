function [ cost, grad ] = stackedAECost(theta, inputSize, hiddenSize, ...
                                              numClasses, netconfig, ...
                                              lambda, data, labels)
                                         
% stackedAECost: Takes a trained softmaxTheta and a training data set with labels,
% and returns cost and gradient using a stacked autoencoder model. Used for
% finetuning.
                                         
% theta: trained weights from the autoencoder
% visibleSize: the number of input units
% hiddenSize:  the number of hidden units *at the 2nd layer*
% numClasses:  the number of categories
% netconfig:   the network configuration of the stack
% lambda:      the weight regularization penalty
% data: Our matrix containing the training data as columns.  So, data(:,i) is the i-th training example. 
% labels: A vector containing labels, where labels(i) is the label for the
% i-th training example
% 奇怪, 这里没有稀疏度正则项参数? 是因为微调不会把原本稀疏的表示变得特别不稀疏, 所以可以接受吗?

%% Unroll softmaxTheta parameter

% We first extract the part which compute the softmax gradient
softmaxTheta = reshape(theta(1:hiddenSize*numClasses), numClasses, hiddenSize);

% Extract out the "stack"
stack = params2stack(theta(hiddenSize*numClasses+1:end), netconfig);

% You will need to compute the following gradients
% softmaxThetaGrad = zeros(size(softmaxTheta));
stackgrad = cell(size(stack));
for d = 1:numel(stack)
    stackgrad{d}.w = zeros(size(stack{d}.w));
    stackgrad{d}.b = zeros(size(stack{d}.b));
end

cost = 0; % You need to compute this

% You might find these variables useful
M = size(data, 2);
groundTruth = full(sparse(labels, 1:M, 1));


%% --------------------------- YOUR CODE HERE -----------------------------
%  Instructions: Compute the cost function and gradient vector for 
%                the stacked autoencoder.
%
%                You are given a stack variable which is a cell-array of
%                the weights and biases for every layer. In particular, you
%                can refer to the weights of Layer d, using stack{d}.w and
%                the biases using stack{d}.b . To get the total number of
%                layers, you can use numel(stack).
%
%                The last layer of the network is connected to the softmax
%                classification layer, softmaxTheta.
%
%                You should compute the gradients for the softmaxTheta,
%                storing that in softmaxThetaGrad. Similarly, you should
%                compute the gradients for each layer in the stack, storing
%                the gradients in stackgrad{d}.w and stackgrad{d}.b
%                Note that the size of the matrices in stackgrad should
%                match exactly that of the size of the matrices in stack.
%
% forward pass
%这个代码是中科院的一个博士完善的代码，运行MNIST数据集的结果较好
layer_num = numel(stack);
activation = cell(1, layer_num+1);%这里行列的顺序和作者网页上给定的不一样，行列相反了
activation{1} = data;

for i = 1:layer_num
    activation{i+1} = sigmoid(bsxfun(@plus, stack{i}.w * activation{i}, stack{i}.b));%下一层的输入值
end

% backward pass
%这里跟作者主页上的代码也不太一样
y = softmaxTheta * activation{layer_num+1};
y = exp(bsxfun(@minus, y, max(y, [], 1)));%减去最大值
y = bsxfun(@rdivide, y, sum(y));%除以总和

cost = -sum(log(y(logical(groundTruth)))) / M + lambda/2 * sum(sum(softmaxTheta.^2));
%logical是将数值变换为逻辑值
delta = y - groundTruth;
softmaxThetaGrad = delta * activation{layer_num+1}' / M + lambda * softmaxTheta;
delta = softmaxTheta' * delta .* activation{layer_num+1} .* (1-activation{layer_num+1});

for i = layer_num:-1:2
    stackgrad{i}.w = delta * activation{i}' / M;
    stackgrad{i}.b = mean(delta, 2);
    delta = stack{i}.w' * delta .* activation{i} .* (1-activation{i});
end

stackgrad{1}.w = delta * activation{1}' / M;
stackgrad{1}.b = mean(delta, 2);

% -------------------------------------------------------------------------

%% Roll gradient vector
grad = [softmaxThetaGrad(:) ; stack2params(stackgrad)];

end


% You might find this useful
function sigm = sigmoid(x)
    sigm = 1 ./ (1 + exp(-x));
end
