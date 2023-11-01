function W = Wavmat(h, N, k0, shift)
% Wavmat -- Transform  Matrix Representation of Orthogonal Discrete Wavelet Transform
%  Usage
%    W = Wavmat(h, N, k0, shift)
%  Inputs
%    h      low-pass filter corresponding to orthogonal WT
%    N      size of matrix/length of data. Should be power of 2.
%      
%    k0     depth of transformation. Ranges from 1 to J=log2(N).
%           Default is J. 
%    shift  the matrix is not unique an any integer shift gives
%           a valid transformation. Default is 2.
%  Outputs
%    W      N x N transformation matrix 
%
%  Description
%    For a quadrature mirror filter h (low pass) the wavelet
%    matrix is formed. The algorithm is described in 
%    [BV99] Vidakovic, B. (1999). Statistical Modeling By Wavelets, Wiley,
%    on pages 115-116.
%    Any shift is leads to a valid wavelet transform.  Size N=1024 is still managable on a standard PC.
%
%  Usage
%    We will mimic the example 4.3.1 from [BV99] page 112.
%   > dat=[1 0 -3 2 1 0 1 2];
%   > W = Wavmat(MakeONFilter('Haar',99),2^3,3,2);
%   > wt = W * dat' %should be [sqrt(2)  |  -sqrt(2) |   1 -1  | ...         
%              %  1/sqrt(2) -5/sqrt(2) 1/sqrt(2) - 1/sqrt(2) ]
%   > data = W' * wt % should return you to the 'dat'
%
%  See Also
%    FWT_PO, IWT_PO, MakeONFilter
%
if nargin==3
    shift = 1;
end
J = log2(N);
if nargin==2
    shift = 2;
    k0 = J;
end
%--make QM filter G
     h=h(:)';  g = fliplr(conj(h).* (-1).^(1:length(h)));
if (J ~= floor(J) )
    error('For standard DWT, N has to be a power of 2.')
end
h=[h,zeros(1,N)]; %extend filter H by 0's to sample by modulus
g=[g,zeros(1,N)]; %extend filter G by 0's to sample by modulus
oldmat = eye(2^(J-k0)); 
for k= k0:-1:1
    clear gmat; clear hmat;
         ubJk = 2^(J-k); ubJk1 = 2^(J-k+1);
   for  jj= 1:ubJk
       for ii=1:ubJk1
           modulus = mod(N+ii-2*jj+shift,ubJk1);
         %  modulus = mod(shift+ii-2*jj,ubJk1);
           modulus = modulus + (modulus == 0)*ubJk1;
           hmat(ii,jj) = h(modulus);
           gmat(ii,jj) = g(modulus);
       end
   end
  W = [oldmat * hmat'; gmat' ];
   oldmat = W;
end
%
% 
% Copyright (c) 2004. Brani Vidakovic
%        
%  
% ver 1.0 Built 8/24/04; ver 1.2 Built 12/1/2004
% This is Copyrighted Material
% Comments? e-mail brani@isye.gatech.edu
%   