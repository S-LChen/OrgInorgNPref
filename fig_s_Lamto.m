ya1=[];
yb1=[];
yb2=[];
ya2=[];
yb3=[];
for i=[0:0.002:0.008,0.01:0.01:1]  
    beta=i;
   
    u0=0.14186;
    u1=u0; u2=u0; d=0.6; lp=0.4; c=0; f=0.01;
    Rd=16.5; Rl=0; m=0.025; k=0.00428107; ld=0.0027;
    lo=0.005;
    Ri=27.1; li=2.7133;%Lamto site 
    tn=3000;x0=[100;100;20;10];
  
    [t,x]=ode45(@N_model,[0,tn],x0,[],beta,u1,u2,d,lp,c,f,Rd,m,k,ld,Rl,lo,Ri,li);

    Pi=x(end,1);
    ND=x(end,2);
    ya1=[ya1,Pi]; % The vector of plant N variation with β
    No=x(end,3);
    yb1=[yb1,No]; % The vector of FAA variation with β
    Ni=x(end,4);
    yb2=[yb2,Ni]; % The vector of inorgnic N variation with β
    Phi=Pi*(d+lp+c);
    ya2=[ya2,Phi]; % Productivity
    Nlos=Ri+(k+m)*ND-Phi+f*Pi;
    yb3=[yb3,Nlos]; % Soil N loss
end 
ya1diff=ya1+0.1;
yb1;
yb2;
ya2;
yb3;

x=[0:0.002:0.008,0.01:0.01:1];

[a,b]=max(ya1);% Find the β value maximizes P
Pmax=a;
betaopt=x(1,b);
[a1,b1]=max(ya2);

[a2,b2]=min(yb3);% Find the β value minimizes P
Nlosmin=a2;
betalosmin=x(1,b2);

Production=Pmax*(d+lp+c);
NO=yb1(find(x == betaopt));  %soil FAA
NI=yb2(find(x == betaopt));  %soil inorganic nitrogen
[betaopt;Pmax;Production;NO;NI]   %results of simulation 

%figure
%plot(x,ya1diff);
%hold on
%plot(x,ya2),legend('Plant N','Production');
%hold on
%plot([betaopt betaopt], [0 Pmax], '--k','HandleVisibility', 'off');
%plot(betaopt,Pmax,'.k',betaopt,a1,'.k','MarkerSize', 10,'HandleVisibility', 'off')
%ylim([0 150])

%figure
%plot(x,yb1,'r-');
%hold on
%plot(x,yb2,'b-');
%hold on
%plot(x,yb3,'k-');
%xline(betaopt,'--k','HandleVisibility', 'off');
%plot(betaopt,a2,'.k',betaopt,NO,'.k',betaopt,NI,'.k','MarkerSize', 10,'HandleVisibility', 'off')
%ylim([0 115])
%legend('Soil FAA','Soil Inorganic N','N loss');
%hold off