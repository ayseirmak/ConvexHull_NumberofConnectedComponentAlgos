clc
clear
close all
% img=[1 1 1 0 0 0 0 0;
%      1 1 1 0 1 1 0 0;
%      1 1 1 0 1 1 0 0;
%      1 1 1 0 0 0 1 0;
%      1 1 1 0 0 0 1 0;
%      1 1 1 0 0 0 1 0;
%      1 1 1 0 0 1 0 0;
%      1 1 1 0 0 0 0 0];
%  imshow(img);
img2=imread('HS-Hydra.png');
img_g=rgb2gray(img2);
[row,colum]=size(img_g);
for r=1:row 
        for c=1:colum
            if  img_g(r,c)<200
               img(r,c)=0;
           else
               img(r,c)=1;
           end
        end 
end

N8=[1 1 1;
    1 1 1;
    1 1 1
    ];

p=fix(length(N8)/2);
padding=zeros(row+p*2,colum+p*2);
for r=p+1:row+p
        for c=p+1:colum+p
            padding(r,c)=img(r-p,c-p);
        end
end
P=zeros(row+p*2,colum+p*2);
result2=zeros(row+p*2,colum+p*2);
result=zeros(row+p*2,colum+p*2);
[r_first_point,c_first_point]=find(padding,1);
P(r_first_point,c_first_point)=1;
 seg=1;
    iter=0;
while(true)
    iter=iter+1;
     for r=p+1:row+p
                for c=p+1:colum+p
                    if(P(r,c)==1)
                        window=P(r-p:r+p,c-p:c+p);
                        n=false;
                        for rw= 1:length(N8)
                            for cw= 1:length(N8)
                                if(window(rw,cw)==N8(rw,cw)&&window(rw,cw)==1)
                                    n=true;
                                end
                            end
                        end
                        if(n==true)
                            result(r-p:r+p,c-p:c+p) =1;
                            if(result2(r,c)==0)
                              result2(r-p:r+p,c-p:c+p) =seg;
                          end
                        end
                    end      
            end
     end
     result=result&padding;
     result2=intesect(result2,padding);
     if(result==P)
         seg=seg+1;
         [r_point,c_point]=find(padding-result,1);
         P(r_point,c_point)=1;
     elseif(result==padding)
         break;
     else
         P=result;
     end
end
label=zeros(1,seg);
[r1,c1]=size(result2);
for r=1:r1
    for c=1:c1
        if(result2(r,c)>0)
            k=result2(r,c);
            label(1,k)=label(1,k)+1;
        end
    end
end
disp("Number of connected component:"+seg);
for(r=1:seg)
    disp("Connected component"+r+": Number of pixel: "+label(1,r));
end
function output = intesect(res2,padd)
[row,colum]=size(res2);
for r=1:row
    for c=1:colum
        if(res2(r,c)>=1&&padd(r,c)~=1)
            res2(r,c)=0;
        end
    end
end
output=res2;
end


