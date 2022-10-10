function Apriori(T, minSup)
    M = size(T,1);    %T的行数M：事务（项集）数
    N = size(T,2);    %T的行数N：项（属性）数
    % 查找大小为1的常见项集（所有满足最小支持度的项目的列表）
    L = {};
    for i = 1:N
        S = sum(T(:,i))/M;   %计算候选项集支持度
        if S >= minSup
            L = [L; i];
        end
    end
    LL = L;
    %查找大小大于等于2的常见项集，并使用最小置信度从中找出规则
    disp(numel(LL));  %输出LL中元素个数
% 初始化计数器
    k = 1;  %频繁项集的项数
% 迭代次数
    while ~isempty(LL)  %可以直接用这个isempty()函数来判空。while循环是生成频繁项集的大循环41-87行,由L{k}-->L{k+1}变化
        C = {};  %候选项集集合
        L = {};  %频繁项集集合
        w = 0;    
        for r = 1:numel(LL)
            for i = r:(numel(LL)-1)
                Ecount = 0;
                for j = 1:(k-1)
                    if(LL{r}(j) == LL{i+1}(j)) %两列的事务矩阵进行相”与”操作
                        Ecount = Ecount + 1;   %支持度+1
                    else
                        break;
                    end
                end
                if(Ecount == (k-1))
                    w = w+1;
                    NEW = LL{r};
                    NEW(k+1) = LL{i+1}(k);
                    C{w} = NEW;  %把这个符合条件的NEW集归于C候选集合
                else
                    break;
                end
            end
        end
        w = 0;
        for r = 1:numel(C)            
            S = T(:,C{r});
            [~, x] = size(S);
            SS = ones(M,1);
            for i = 1:x
                SS = SS & (S(:,i));
            end
            Sup = sum(SS)/M;
            if Sup >= minSup
                w = w+1;
               L{w} = C{r};
            end
        end
        LL = L;
        disp(numel(LL));
        % 增量计数器
        k = k+1;
    end
end