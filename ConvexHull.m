clc
clear
close all

% img=[0 0 0 0 0 0 0 0 0 0
%      0 0 0 1 1 1 0 0 0 0;
%      0 0 1 1 1 1 1 0 0 0;
%      0 0 1 1 1 1 0 0 0 0;
%      0 0 0 0 1 1 0 1 0 0;
%      0 0 0 0 1 1 0 1 0 0;
%      0 0 0 0 1 1 1 0 0 0;
%      0 0 0 0 0 0 1 0 0 0;
%      0 0 0 0 0 0 1 0 0 0;
%      0 0 0 0 0 0 1 0 0 0;
%      0 0 0 0 0 1 1 0 0 0;
%      0 0 0 0 0 1 0 0 0 0
%      0 0 0 0 0 0 0 0 0 0] ;
% [row,colum]=size(img);
img2=imread('HS-Hydra.png');
img_g=rgb2gray(img2);
[row,colum]=size(img_g);
for r=1:row 
        for c=1:colum
            if  img_g(r,c)<150
               img(r,c)=0;
           else
               img(r,c)=1;
           end
        end 
end



R1=[1 NaN NaN;
    1 0 NaN;
    1 NaN NaN
    ];
R2=[1 1 1;
    NaN 0 NaN;
    NaN NaN NaN
    ];
R3=[NaN NaN 1;
    NaN 0 1;
    NaN NaN 1
    ];
R4=[NaN NaN NaN;
  	NaN 0 NaN;
    1 1 1
    ];
p=fix(length(R1)/2);

padding=zeros(row+p*2,colum+p*2);
for r=p+1:row+p
        for c=p+1:colum+p
            padding(r,c)=img(r-p,c-p);
        end
end
result=padding;
resultf= zeros(row+p*2,colum+p*2);
[padding1,result1]=convex_hull(padding,result,R1,img,2);
[padding2,result2]=convex_hull(padding,result,R2,img,3);
[padding3,result3]=convex_hull(padding,result,R3,img,4);
[padding4,result4]=convex_hull(padding,result,R4,img,5);

padding_f=padding1|padding2|padding3|padding4;
for r=p+1:row+p
        for c=p+1:colum+p
            if(padding(r,c)==0)
                if(result1(r,c)~=0.0)
                    resultf(r,c)=result1(r,c);
                elseif(result2(r,c)~=0)
                    resultf(r,c)=result2(r,c); 
                elseif(result3(r,c)~=0)
                    resultf(r,c)=result3(r,c);
                elseif(result4(r,c)~=0)
                    resultf(r,c)=result4(r,c);
                end
            else
                resultf(r,c)=1;
            end
        end
end
imshow(mat2gray(resultf));

function [padding, result] = convex_hull (padding,result,R,img,i)
iter=0;
r1=true;
[row,colum]=size(img);
p=fix(length(R)/2);
while(true)
    P=zeros(row+p*2,colum+p*2);
    iter=iter+1;
    for r=p+1:row+p
        for c=p+1:colum+p   
                window=padding(r-p:r+p,c-p:c+p);
                r1=true;
                for rw= 1:length(R)
                    for cw= 1:length(R)
                        if(isnan(R(rw,cw)))
        %                    do nothing
                        elseif(R(rw,cw)~=window(rw,cw))
                                r1=false;
                        end
                    end
                end    
                if(r1==true)
                    P(r,c)=1;
                    result(r,c)=i;
                end
        end
    end
    if(sum(P)==0)
        break;
    else
        padding=padding|P;
    end
    
end
end
