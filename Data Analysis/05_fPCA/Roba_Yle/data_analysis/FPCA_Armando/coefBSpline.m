function [Coeff,index] = coefBSpline( t )
    
    k = length(t) - 1;
    if k > 1
       adds= ones(1,k-1);
       tt = [adds*t(1), t(:)', adds*t(k+1)];
       j= k + 1;
       a= [adds*0,    1,     adds*0];
       inter = find(diff(tt)>0); 
       L= length(inter);
       onesk = ones(1,2*(k-1));
       onesL = ones(L,1);
       tx= onesL*[2-k:k-1] + inter'*onesk;
       tx(:) = tt(tx);
       tx= tx - tt(inter)'*onesk;
       b= onesL*[1-k:0]  + inter'*ones(1,k);
       b(:) = a(b);
       km1 = k-1; 
       for r=1:km1
          for i=1:k-r
             b(:,i) =(tx(:,i+km1).*b(:,i)-tx(:,i+r-1).*b(:,i+1))./(tx(:,i+km1)-tx(:,i+r-1));
          end
       end
       Coeff = b;
       for r=2:k
          factor = (k-r+1)/(r-1);
          for i=k:-1:r
             Coeff(:,i) = (Coeff(:,i) - Coeff(:,i-1))*factor./tx(:,i+k-r);
          end
       end
       Coeff = Coeff(:,k:-1:1);
       index = inter - (k-1);
    else
       Coeff = 1;
       index = 1;
    end
end

