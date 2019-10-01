function change_map = detectChange(obj, t1, t2)
    % Be cautious that the output value WILL be truncated
    change_map = abs(double(t1) ./ (double(t2) + eps));
end

