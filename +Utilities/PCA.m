function [pcs, v, e] = PCA(im, k)
% Refer to http://people.compute.dtu.dk/alan/software.html
[rows, cols, chns] = size(im);
if chns > 1
    flat = reshape(double(im), rows*cols, chns);
else
    % For 2D matrices, treat as reshaped ones
    flat = double(im);
    chns = cols;
end
flat = flat - mean(flat, 1);    % Remove mean

sigma = cov(flat);

[v, e] = eig(sigma);
% Eigenvalues in descending order
[~,idx] = sort(diag(e), 'descend');
v = v(:,idx);

% Sum of correlations between im and pcs positive
% Not sure if this step is just necessary
invStdIm = diag(1./std(flat));
invStdPC = diag(1./sqrt(diag(v'*sigma*v))); % Utilize the cov matrix
sgn = diag(sign(sum(invStdIm*sigma*v*invStdPC)));
v = v * sgn;

% Unitize the vectors
v = v ./ sqrt(sum(v.*v, 1));

% Make PCs
k = min(k, chns);
pcs = flat * v(:, 1:k);

if ndims(im) == 3
    pcs = reshape(pcs, rows, cols, k);
end
end