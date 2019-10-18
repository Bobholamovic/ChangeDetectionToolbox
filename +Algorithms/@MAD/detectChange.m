function [DI, k] = detectChange(obj, t1, t2)
    % A naive implementation of the Multivariate Alteration Detection Algorithm
    % Partially refer to http://people.compute.dtu.dk/alan/software.html
    % and https://github.com/mortcanty/earthengine
    %
    % This primitive version works only for nBands(t1) = nBands(t2)
    [rows, cols, chns] = size(t1);
    x1 = reshape(double(t1), cols*rows, chns);
    x1 = x1 - mean(x1, 1);  % Subtract mean
    x2 = reshape(double(t2), cols*rows, chns);
    x2 = x2 - mean(x2, 1);
    sigma = cov([x1 x2]);
    sigma11 = sigma(1:chns, 1:chns);
    sigma12 = sigma(1:chns, chns+1:end);
    sigma21 = sigma(chns+1:end, 1:chns);
    sigma22 = sigma(chns+1:end, chns+1:end);
    
    [a, e1] = eig(sigma12 / sigma22 * sigma21, sigma11);
    e1 = sqrt(diag(e1));
    [b, e2] = eig(sigma21 / sigma11 * sigma12, sigma22);
    e2 = sqrt(diag(e2));
    [e1, idx1] = sort(e1, 'ascend');
    a = a(:,idx1);  % Sort the vectors in ascending order of eigenvalues
    [e2, idx2] = sort(e2, 'ascend');
    b = b(:,idx2);
    
    % Normalize a for unit dispersion
    % Ensure that a'*s11*a=I to meet the constraints
    vars1 = (a'*sigma11*a);
    a = a ./ sqrt(diag(vars1))';
    % Similiar operations on b
    vars2 = (b'*sigma22*b);
    b = b ./ sqrt(diag(vars2))';
    
    % Ensure sum of positive correlations between x1 and x1*a is positive
    % I have no idea what this is used for???
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
    prob = chi2cdf(chi2, chns);
    DI = reshape(abs(mad), rows, cols, chns);
    
    % Select bands
    k = min(chns, obj.nMADUsed);
    DI = DI(:,:,1:k);
end