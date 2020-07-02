function [ s1,s2,s3 ] = segmentation(s)
%this functions splits a signal in 3 segments in order to divide 3
%repetitions of a signal
    p = zeros(1,3);

    S = sum(s);
    flag = 0;
    if S < 0
        flag = 1;
        s = -s;
    end

    s = s - min(s);

    [pks,locs] = findpeaks(s,'MinPeakDistance',100);


    %find higher
    [~,I] = max(pks);
    p(1) = locs(I);
    pks(I)=0;

    %find the second 
    [~,I] = max(pks);
    p(2) = locs(I);
    pks(I)=0;

    %find the third 
    [~,I] = max(pks);
    p(3) = locs(I);


    %evaluate function derivative near peaks
    d1 = diff(s(p(1)-100:p(1)));
    d1 = abs(mean(d1));

    d2 = diff(s(p(1):p(1)+100));
    d2 = abs(mean(d2));

    d3 = diff(s(p(2)-100:p(2)));
    d3 = abs(mean(d3));

    d4 = diff(s(p(2):p(2)+100));
    d4 = abs(mean(d4));

    d5 = diff(s(p(3)-100:p(3)));
    d5 = abs(mean(d5));

    d6 = diff(s(p(3):p(3)+100));
    d6 = abs(mean(d6));

    p = sort(p);

    m1 = p(1) + round((p(2)-p(1))/2);
    m2 = p(2) + round((p(3)-p(2))/2);

%     m1 = round(( d3*p(1) + d2*p(2) )/(d2+d3));
%     m2 = round(( d5*p(2) + d4*p(3) )/(d4+d5));

    if flag == 1
        s = -s;
    end
    
    s1 = s(1:m1);
    s2 = s(m1:m2);
    s3 = s(m2:end);

end

