% Testing the growth transform properties as a function of the parameters
thr = 0.0001;
iter = 1;
decay = 0.99;
dp = zeros(nNeuron,1);
dpprev = dp;
a = ;

while a 
quant = 3*(dp > thr) - 0.0*(dp <= thr);
G = 1*netI - Q*dp - 0*dp - quant; % Gradient
%        G = netI - 1*(I - Q)*dp - quant; % Gradient         
        dp = (G + Fac*dp)./(dp.*G + Fac);
%        dp

        a_iter = 0.01;
        if dp > thr,
            dp = -1;
        else
            dp = a_iter.*dp + (1-a_iter).*dpprev;
        end