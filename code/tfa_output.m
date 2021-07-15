function [col2] = tfa_output(p1,v1,fs,params,field_indices)
%TFA_OUTPUT run tfa algorithm and output the desired values (specified by
%field indices). Allows for flexibility with different params.

tfa_out=tfa_car(p1,v1,fs,params); % appy tfa
tfa_cell = struct2cell(tfa_out);
tfa_cell(6:11,:) = []; % remove the doubles
tfa_mat = cell2mat(tfa_cell);

col2 = zeros(size(field_indices));
for i = 1:length(field_indices)
    j = field_indices(i);
    value = tfa_mat(j);
    col2(i) = value;
end


end

