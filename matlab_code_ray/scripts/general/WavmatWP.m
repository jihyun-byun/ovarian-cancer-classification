%function W= WavPackMat()
function WP = WavPackMat(h, N, k0, shift)
% WavPackmat -- Transformation Matrix for Wavelet Packet
%  Usage
%    W = WavPackmat(h, N, k0)
%  Inputs
%    h      low-pass filter corresponding to orthogonal WT
%    N      size of matrix/length of data. Should be power of 2.
%      
%    k0     depth of transformation. Ranges from 1 to J=log2(N).
%           Default is J. 


%   Usage
%    We will mimic the example 4.3.1 from [BV99] page 112.
%   > dat=[1 0 -3 2 1 0 1 2];
%   > W = WavPackMat(MakeONFilter('Haar',99),2^3,3, 2);


%N = 8;
J = log2(N);
%shift = 2;
%k0=3;
%h = MakeONFilter('Haar',99);
%h = [(1+sqrt(3))/(4*sqrt(2)),(3+sqrt(3))/(4*sqrt(2)),(3-sqrt(3))/(4*sqrt(2)),(1-sqrt(3))/(4*sqrt(2))];
%y=[1,0,-3,2,1,0,1,2];

%--make QM filter G
h=h(:)';  g = fliplr(conj(h).* (-1).^(1:length(h)));
if (J ~= floor(J) )
    error('N has to be a power of 2.')
end
h=[h,zeros(1,N)]; %extend filter H by 0's to sample by modulus
g=[g,zeros(1,N)]; %extend filter G by 0's to sample by modulus


WP = [];
for k= 1:k0
  subW=getsubW(k, h, g, J,N);
  WP = [WP;subW];   
end
 WP = sqrt(1/k0)* WP;
 

% Subroutines needed

function subW=getsubW(jstep, h, g, J, N)

subW = eye(2^(J-jstep));
for k=jstep:-1:1
   [hmat, gmat] = getHGmat(k, h, g, J, N);
%    subW =  [subW*hmat';gmat'];
    subW =  [subW*hmat;subW*gmat];
end


% Refer to Eq4.8 in P115 of Vidakovic's Statistical Modeling by Wavelets
%function [hmat, gmat] = getHGmat(k, h, g, J, N)
function [hmat, gmat] = getHGmat(k, h, g, J, N)
ubJk = 2^(J-k);
ubJk1 = 2^(J-k+1);
%shift is an issue here by Ethan
%shift=3 matches Vidakovic's wavelets book
%shift = 2, default value for Brian's code 
shift=2;
for  jj= 1:ubJk
   for ii=1:ubJk1
       modulus = mod(N+ii-2*jj+shift,ubJk1);
%        modulus = mod(N+ii-2*jj,ubJk1);
       modulus = modulus + (modulus == 0)*ubJk1;
       hmat(ii,jj) = h(modulus);
       gmat(ii,jj) = g(modulus);
   end
end

hmat = hmat';
gmat = gmat';




