function [QCC] = makeQCC(CC,binsPerCC,n)
%UNTITLED6 Summary of this function goes here
%   Returns a column vector

CC = squeeze(CC);
binsPerCC = squeeze(binsPerCC);

QCC = zeros(n,1);
i = 1;
while i <= n
    [nmax,nmaxi] = max(binsPerCC);
    endi = i+nmax-1;
    if endi > n
        endi = n;
    end
    QCC([i:endi]) = CC(nmaxi,1);
    binsPerCC(nmaxi) = 0;
    if nmax == 0 % catch in case there are less than n dominant colors
        error('makeQCC: not enough dominant colors found!')
    end
    i = i + nmax;
end
end

