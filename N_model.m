function dx = N_model(t,x,beta,u1,u2,d,lp,c,f,Rd,m,k,ld,Rl,lo,Ri,li)
   dx=[beta*u1*x(1)*x(3)+(1-beta)*u2*x(1)*x(4)-d*x(1)-lp*x(1)-c*x(1)+f*x(1);
       Rd+Rl+d*x(1)-m*x(2)-k*x(2)-ld*x(2);
       k*x(2)-beta*u1*x(1)*x(3)-lo*x(3);
       Ri+m*x(2)-(1-beta)*u2*x(1)*x(4)-li*x(4)];
end