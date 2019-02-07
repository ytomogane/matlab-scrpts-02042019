function [abof] = abod(X)
    n = size(X);
    d = n(2);
    n = n(1);
    res = zeros(n,1);
    for i = 1:n
        Y = X - repmat(X(i,:),n,1);
        temp = Y.^2;
        s = sum(temp,2);
        s = repmat(s,1,d);
        Y = Y./s;
        Y(isnan(Y))=0;
        res(i) = compAngvar(Y);
    end
    abof = res;
end

function [anglevar] = compAngvar(Y)
    tmp = Y * Y';
    s  = tril(tmp,-1);
    [r,c,v] = find(s);
    anglevar = var(v);
end