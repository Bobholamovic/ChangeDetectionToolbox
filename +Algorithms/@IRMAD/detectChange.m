function [DI, k, mad, w, chi2]  = detectChange(obj, t1, t2)
% Refer to http://people.compute.dtu.dk/alan/software.html
[rows, cols, chns1] = size(t1);
chns2 = size(t2, 3);
chns = min(chns1, chns2);
N = rows*cols;
w = ones(N, 1); % Initial weights
t1_ = reshape(double(t1), N, chns1);
t2_ = reshape(double(t2), N, chns2);
rhos = [];

for ii = 1:obj.nIters
    [sigma, xc] = covW(obj, [t1_, t2_], w);
    x1 = xc(:,1:chns1);
    x2 = xc(:,chns1+1:end);
    sigma11 = sigma(1:chns1, 1:chns1);
    sigma12 = sigma(1:chns1, chns1+1:end);
    sigma21 = sigma(chns1+1:end, 1:chns1);
    sigma22 = sigma(chns1+1:end, chns1+1:end);
    
    [a, e1] = eig(sigma12 / sigma22 * sigma21, sigma11);
    e1 = sqrt(diag(e1));
    [b, e2] = eig(sigma21 / sigma11 * sigma12, sigma22);
    e2 = sqrt(diag(e2));
    [e1, idx1] = sort(e1, 'descend');
    a = a(:,idx1);
    a = a(:,chns:-1:1);
    e1 = e1(chns:-1:1);
    [e2, idx2] = sort(e2, 'descend');
    b = b(:,idx2);
    b = b(:,chns:-1:1);
    e2 = e2(chns:-1:1);
    
    % Normalize a for unit dispersion
    % Ensure that a'*s11*a=I to meet the constraints
    vars1 = (a'*sigma11*a);
    a = a ./ sqrt(diag(vars1))';
    % Similiar operations on b
    vars2 = (b'*sigma22*b);
    b = b ./ sqrt(diag(vars2))';
    
    % Ensure sum of positive correlations between x1 and x1*a is positive
    invStd1 = diag(1./std(x1));
    sgn = diag(sign(sum(invStd1*sigma11*a)));
    a = a*sgn;
    
    % Assure positive correlation between pair of canonical variates
    b = b .* diag(sign(a'*sigma12*b))';
    
    mad = x1*a - x2*b;
    
    % Normalize mad
    % This is no regular operation, yet appears to improve the result
    mad = (mad - mean(mad)) ./ (std(mad)+eps);
    chi2 = sum(mad.^2, 2);
    
    %         chi2 = sum(mad.^2 ./ (2*(1-e1')), 2);   % Should be no-change std only
    
    w = 1 - chi2cdf(chi2, chns);
    
    if ii > 1
        err = max(abs(e1'-rhos(end,:)));
        if err < obj.epsilon, break; end
    end
    rhos = [rhos; e1'];
end

if ii == obj.nIters
    warning('Exceeded max number of iterations.')
end

%     % Use L2 pooling
%     DI = reshape(sqrt(sum(mad.*mad, 2)), rows, cols);

mad = reshape(mad, rows, cols, chns);
w = reshape(w, rows, cols);
chi2 = reshape(chi2, rows, cols);
k = min(chns, obj.nMADUsed);
DI = abs(mad(:,:,1:k));
end