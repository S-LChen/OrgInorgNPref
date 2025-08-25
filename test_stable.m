for i=0:0.01:1
   beta=i;
   
   u1=0.01336; u2=0.01336; d=0.258; lp=0; c=0; f=0.01;
   Rd=0; Rl=0; m=0.00654; k=0.00428107; ld=0.00138;
   lo=0.03;
   Ri=6; li=0.2;    %Pawnee site  
   

   %u1=0.000678321*21; u2=0.0011805*21; d=0.175526; lp=0; c=0.6;
   %Rd=3.03; Rl=716.532; m=0.01335; k=0.00589984; ld=0.001771;
   %lo=0.03;
   %Ri=25.3828; li=0.4174; %community with grazing 

   tn=17000;x0=[100;100;20;10];

   [t,x]=ode45(@N_model,[0,tn],x0,[],beta,u1,u2,d,lp,c,f,Rd,m,k,ld,Rl,lo,Ri,li);

   Pi=x(end,1);
   D=x(end,2);
   No=x(end,3);
   Ni=x(end,4);

   syms x y z w
   % Define the system

   e = beta*u1*x*z+(1-beta)*u2*x*w-d*x-lp*x-c*x;
   f = Rd+Rl+d*x-m*y-k*y-ld*y;
   g = k*y-beta*u1*x*z-lo*z;
   h = Ri+m*y-(1-beta)*u2*x*w-li*w;

   % Jacobian matrix
   J = jacobian([e, f, g, h], [x, y, z, w]);

   % Calculate the eigenvalues at the specified point (X,Y,Z,W)
   X = Pi; Y = D; Z = No; W = Ni; % Replace the point to calculated by ODE45
   J_eq_specified = double(subs(J, [x, y, z, w], [X, Y, Z, W]));
   eigenvalues_specified = eig(J_eq_specified);
   fprintf('Eigenvalues of specified equilibrium (%.2f, %.2f, %.2f, %.2f): %.2f %.2f %.2f %.2f\n', X, Y, Z, W, eigenvalues_specified);
   if all(real(eigenvalues_specified) < 0)
       fprintf('stable\n');
   elseif any(real(eigenvalues_specified) > 0)
       fprintf('unstable\n');
   else
       fprintf('saddle point\n');
   end
   fprintf('------------------------\n');
end
