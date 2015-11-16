function [ lfsrSeq ] = generateLfsrSequence( n, ciVec, a0Vec )
% Generate a 1/0-valued linear feedback shift register (LFSR) sequence.
%
% INPUTS
%
% n ------ Number of stages in the linear feedback shift register.
%
% ciVec -- Nc-by-1 vector whose elements give the indices of the Nc nonzero
% connection elements. For example, if the characteristic polynomial
% of an LFSR is f(D) = 1 + D^2 + D^3, then ciVec = [2,3]’ or [3,2]’.
%
% a0Vec -- n-by-1 1/0-valued initial state of the LFSR, where a0Vec = [a(-1),
% a(-2), ..., a(-n)]’. In defining the initial LFSR state, a
% Fibonacci LFSR implementation is assumed.
%
% OUTPUTS
%
% lfsrSeq -- m-by-1 vector whose elements are the 1/0-valued LFSR sequence
% corresponding to n, ciVec, and a0Vec, where m = 2^n - 1. If the
% sequence is a maximal-length sequence, then there is no
% repetition in the m sequence elements.
%
%+------------------------------------------------------------------------------+
% References:
%
%
% Author: Andrew Olguin
%+==============================================================================+
max_len = 2^n-1;

lfsrSeq = zeros([1 max_len]);

sr = a0Vec';
c = zeros([1 n]);
for i=1:length(ciVec)
    c(ciVec(i)) = 1;
end
tmp_ai = [];

for m = 1:max_len
    lfsrSeq(1,m) = sr(end);
    tmp_sr = c .* sr;
    for i = 1:length(tmp_sr)-1
        if isempty(tmp_ai)
            tmp_ai = xor(tmp_sr(i), tmp_sr(i+1));
        else
            tmp_ai = xor(tmp_ai, tmp_sr(i+1));
        end
    end
    ai = tmp_ai;
    tmp_ai = [];
    sr(2:end) = sr(1:end-1);
    sr(1) = ai;
end

end

