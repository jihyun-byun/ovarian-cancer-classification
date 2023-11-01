function fBm = MakeFBMNew(n, h, seed)
%
% makes fbm with Hurst exponent H
% using the method of Wood and Chan
if nargin == 2, 
seed = randi([1 10000]);
end;
randn('state',seed);

% --------------------------------------------------------
m=2^(fix(log(n-1)/log(2)+1));

%--------------------circulant eigen-----------------------
k=0:m-1;
h2=2*h;
v=0.5* ( abs(k-1).^h2 - 2* k.^h2 + (k+1).^h2 );
ind=[0:(m/2-1) (m/2):-1:1];
eigC=v(ind+1)/n^h2;

% ----------------------------------------------
% research of the power of two (<2^18) such that
% C is definite positive
% ----------------------------------------------
eigC=fft(eigC);
while ((eigC<=0) & (m<2^17))
m=2*m;

k=0:m-1;
h2=2*h;
v=0.5* ( abs(k-1).^h2 - 2* k.^h2 + (k+1).^h2 );
ind=[0:(m/2-1) (m/2):-1:1];
eigC=v(ind+1)/n^h2;
eigC=fft(eigC);
end
% -----------------------------------------------
% simulation of W=(Q)^t Z, where Z leads N(0,I_m)
% and	(Q)_{jk} = m^(-1/2) exp(-2i pi jk/m)
% -----------------------------------------------
ar=randn(m/2+1,1);
ai=randn(m/2+1,1);
ar(1)= sqrt(2) * ar(1);
ar(m/2+1)= sqrt(2) * ar(m/2+1);
ai(1)=0;
ai(m/2+1)=0;
ar=[ar(1:m/2+1); ar( m/2:-1:2 )];
aic=-ai;
ai=[ai(1:m/2+1); aic(m/2:-1:2)];
W=ar + i*ai;
% -------------------------
% reconstruction of the fGn
% -------------------------
W=sqrt(eigC').* W;
fGn=fft(W);
fGn=fGn/sqrt(2*m);
fGn=real(fGn);
fGn=fGn(1:n);
fBm=cumsum(fGn);

%===================
