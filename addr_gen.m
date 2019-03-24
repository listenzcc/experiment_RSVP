function [im_ctg_No,im_id]=addr_gen(N,tgt_loc,target_ctg_No)
global ctg;global ctg_size;global im_addr;
%generate image addresses
%global variable:
    %im_addr,image address
%external variables:
    %tgt_loc:location of target images in a block
    %N:number of images in a single block
%output:
    %im_ctg_No: array of image category codes 图像分类编码，分属于不同的图像数据库
    %im_id:array of image id in a category    图像ID
for i=1:N
    Kvs = tgt_loc - i;  
    K = find (Kvs==0);
   if K ~= nan; %#ok<FNAN> % || i==tgt_loc(2) || i==tgt_loc(3) || i==tgt_loc(4);  % || i==tgt_loc(length(tgt_loc)) %%%20160509修改,保障一个目标出现
      im_ctg_No(i)=target_ctg_No;
   else
    im_ctg_No(i)=target_ctg_No+1;
   end
    im_id(i)=random('unid',ctg_size(im_ctg_No(i))); %% 每一类图库的内容大小进行随机选择    图像编号
    im_addr(i)={sprintf('images/%s/image_%04d.jpg',char(ctg(im_ctg_No(i))),im_id(i))}; %% 获得所有需要显示的图像信息的路径
end    
end
