% Script to simulate a single neuron based on an optimization procedure
Fac = 10;
N = 100;
v = zeros(N,1);
f = 1;
delT = 0.1;
inp = 0.0;
thd = 0.0;

for i=2:N,
    d = 5*(v(i-1) >= thd) - 1*(v(i-1) < thd);
    grad = (v(i-1) + inp - d);
    v(i)=(1-f*delT)*v(i-1) + f*delT*(grad + Fac*v(i-1))/(v(i-1)*grad + Fac);
end;
figure; plot(v);
    
