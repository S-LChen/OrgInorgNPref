ya1=[];
yb1=[];
yb2=[];
ya2=[];
yb3=[];
for i=0:0.01:1
    beta=i;
    
    u0=0.000678321+0.0011805;
    u1=u0; u2=u0; d=0.15344; lp=0; c=0.5; f=0.091;
    Rd=3.03; Rl=796.1472*0.5; m=0.01335; k=0.0053323; ld=0.001771;
    lo=0.1;
    Ri=10.33+7.526; li=0.4174;    % Haibei community with grazing 

    tn=3000;x0=[100;100;20;10];
  
    [t,x]=ode45(@N_model,[0,tn],x0,[],beta,u1,u2,d,lp,c,f,Rd,m,k,ld,Rl,lo,Ri,li);

    Pi=x(end,1);
    ND=x(end,2);
    ya1=[ya1,Pi];% The vector of plant N variation with β
    No=x(end,3);
    yb1=[yb1,No];% The vector of FAA variation with β
    Ni=x(end,4);
    yb2=[yb2,Ni];% The vector of inorgnic N variation with β
    Phi=Pi*(d+lp+c);
    ya2=[ya2,Phi];% Productivity
    Nlos=Ri+(k+m)*ND-Phi+f*Pi;
    yb3=[yb3,Nlos];% Soil N loss
end 
ya1;
yb1;
yb2;
ya2;
yb3;

x=0:0.01:1;

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
%plot(x,ya1);
%hold on
%plot(x,ya2),legend('Plant N','Production');
%hold on
%plot([betaopt betaopt], [0 Pmax], '--k','HandleVisibility', 'off');
%plot(betaopt,Pmax,'.k',betaopt,a1,'.k','MarkerSize', 10,'HandleVisibility', 'off')
%ylim([0 600])

%figure
%plot(x,ya1, 'Color', [0.227 0.749 0.6], 'LineStyle', '-');
%hold on
%plot(x,ya2, 'Color', [0.1725 0.5686 0.8784], 'LineStyle', '-'),legend('Plant N','Production');
%hold on
%plot([betaopt betaopt], [0 Pmax], '--k','HandleVisibility', 'off');
%plot(betaopt,Pmax,'.k',betaopt,a1,'.k','MarkerSize', 10,'HandleVisibility', 'off')
%ylim([0 600])
%figure
%plot(x,yb1,'r-');
%hold on
%plot(x,yb2,'b-');
%hold on
%plot(x,yb3,'k-');
%xline(betaopt,'--k','HandleVisibility', 'off');
%plot(betaopt,a2,'.k',betaopt,NO,'.k',betaopt,NI,'.k','MarkerSize', 10,'HandleVisibility', 'off')
%ylim([0 108])
%legend('Soil FAA','Soil Inorganic N','N loss');
%hold off

%figure    
%plot(x,yb1,'r-');
%hold on
%plot(x,yb2,'b-');
%hold on
%plot(x,yb3,'k-');
%xline(betaopt,'--k','HandleVisibility', 'off');
%plot(betaopt,a2,'.k',betaopt,NO,'.k',betaopt,NI,'.k','MarkerSize', 10,'HandleVisibility', 'off')
%legend('Soil FAA','Soil Inorganic N','N loss');
%ylim([0 1200])
%hold off

%figure
%plot(x,yb1, 'Color', [0.4863 0.1020 0.5922], 'LineStyle', '-'); 
%hold on
%plot(x,yb2, 'Color', [0.9412 0.6549 0.2275], 'LineStyle', '-');
%hold on
%plot(x,yb3, 'Color', [0.7725 0.1529 0.1765], 'LineStyle', '-');
%xline(betaopt,'--k','HandleVisibility', 'off');
%plot(betaopt,a2,'.k',betaopt,NO,'.k',betaopt,NI,'.k','MarkerSize', 10,'HandleVisibility', 'off')
%legend('Soil FAA','Soil Inorganic N','N loss');
%ylim([0 1200])
%hold off