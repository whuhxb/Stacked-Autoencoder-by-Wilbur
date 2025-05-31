function [params, netconfig] = stack2params(stack)

% Converts a "stack" structure into a flattened parameter vector and also
% stores the network configuration. This is useful when working with
% optimization toolboxes such as minFunc.
%��һ��ջת��Ϊһ����ƽ����ʸ�������Ҵ洢����ṹ���������Ż������䣨��minFunc��������ʱ���������õġ�
% [params, netconfig] = stack2params(stack)
%
% stack - the stack structure, where stack{1}.w = weights of first layer
%                                    ��һ���Ȩ��
%                                    stack{1}.b = basis of first layer
%                                    ��һ���ƫ��
%                                    stack{2}.w = weights of second layer
%                                    �ڶ����Ȩ��
%                                    stack{2}.b = basis of second layer
%                                    �ڶ����ƫ��
%                                    ... etc.


% Setup the compressed param vector ����ѹ����������
params = [];
for d = 1:numel(stack)
    %numel�����������Ǽ���������Ԫ�ظ����������±�������ʽ�ĸ�����
    % This can be optimized. But since our stacks are relatively short, it
    % is okay
    params = [params ; stack{d}.w(:) ; stack{d}.b(:) ]; %��ջ�е�Ԫ����Ϊ�����������
    
    % Check that stack is of the correct form �˶�ջΪ��ȷ�ĸ�ʽ
    assert(size(stack{d}.w, 1) == size(stack{d}.b, 1), ...
        ['The bias should be a *column* vector of ' ...
         int2str(size(stack{d}.w, 1)) 'x1']);
    if d < numel(stack)
        assert(size(stack{d}.w, 1) == size(stack{d+1}.w, 2), ...
            ['The adjacent layers L' int2str(d) ' and L' int2str(d+1) ...
             ' should have matching sizes.']);
    end
    
end

if nargout > 1
    % Setup netconfig
    if numel(stack) == 0
        netconfig.inputsize = 0;
        netconfig.layersizes = {};
    else
        netconfig.inputsize = size(stack{1}.w, 2); %netconfig�Ĵ�С����stack{1}.w������
        netconfig.layersizes = {};
        for d = 1:numel(stack)
            netconfig.layersizes = [netconfig.layersizes ; size(stack{d}.w,1)];
        end
    end
end

end
