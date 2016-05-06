function M = togray(T)
if length(size(T))>2
    M=sum(T,3);
    M=M/max(max(M));
else
    M=T/max(max(T));
end
M=M*(-1)+1;
end

