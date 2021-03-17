function [graddu] = new_reg(x,N)
%This function calculates the new regularization term graddu
%arguments x N=height? of the two image system
i2 = [N/2+1:N,1:N/2];
for j = 1:N
    graddu(j) = x(i2(j));
    %graddu(j) = g(i1(j))*g(i2(j))^2;vanha!
end
graddu = graddu(:);

