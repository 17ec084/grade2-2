function [ output_args ] = diffOfPhiAlphaBeta( A,N )
%DIFFOFPHIALPHABETA φαβをAで微分したもの
%   計算式は次のように求められた。
%   syms phi A N
%   phi=acos(real(((A./(N.^2)).*cos((((2*pi).*A))./N))./sqrt(1./(4.*(1-(A./(N.^2)).^2))-(A./(N.^2).*sin((((2*pi).*A))./N)).^2)));
%   diff(phi,A)
%   使用例を見たい場合は引数を"example"とせよ

if string(A)=="example"
    fprintf("N=10000;\n");
    fprintf("% N=5000だと、正確にプロットされないことが確認されている。\n");
    fprintf("A=[0:N*(N+1)];\n");
    fprintf("y=0;\n");
    fprintf("y=diffOfPhiAlphaBeta( A,N );\n");
    fprintf("plot(A,y);\n");
    output_args="example";
    return;
end
output_args = -(real(cos((2.*pi.*A)./N)./(N.^2.*(- 1./((4.*A.^2)./N.^4 - 4) - (A.^2.*sin((2.*A.*pi)./N).^2)./N.^4).^(1./2))) + real((A.*cos((2.*pi.*A)./N).*((2.*A.*sin((2.*pi.*A)./N).^2)./N.^4 - (8.*A)./(N.^4.*((4.*A.^2)./N.^4 - 4).^2) + (4.*A.^2.*pi.*cos((2.*pi.*A)./N).*sin((2.*pi.*A)./N))./N.^5))./(N.^2.*(- 1./((4.*A.^2)./N.^4 - 4) - (A.^2.*sin((2.*A.*pi)./N).^2)./N.^4).^(3./2)))./2 - 2.*real((A.*pi.*sin((2.*pi.*A)./N))./(N.^3.*(- 1./((4.*A.^2)./N.^4 - 4) - (A.^2.*sin((2.*A.*pi)./N).^2)./N.^4).^(1./2))))./(1 - real((A.*cos((2.*A.*pi)./N))./(N.^2.*(- 1./((4.*A.^2)./N.^4 - 4) - (A.^2.*sin((2.*A.*pi)./N).^2)./N.^4).^(1./2))).^2).^(1./2);


end

