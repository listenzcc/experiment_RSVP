function [im_ctg_No,im_id]=addr_gen(N,tgt_loc,target_ctg_No)
global ctg;global ctg_size;global im_addr;
%generate image addresses
%global variable:
    %im_addr,image address
%external variables:
    %tgt_loc:location of target images in a block
    %N:number of images in a single block
%output:
    %im_ctg_No: array of image category codes ͼ�������룬�����ڲ�ͬ��ͼ�����ݿ�
    %im_id:array of image id in a category    ͼ��ID
for i=1:N
    Kvs = tgt_loc - i;  
    K = find (Kvs==0);
   if K ~= nan; %#ok<FNAN> % || i==tgt_loc(2) || i==tgt_loc(3) || i==tgt_loc(4);  % || i==tgt_loc(length(tgt_loc)) %%%20160509�޸�,����һ��Ŀ�����
      im_ctg_No(i)=target_ctg_No;
   else
    im_ctg_No(i)=target_ctg_No+1;
   end
    im_id(i)=random('unid',ctg_size(im_ctg_No(i))); %% ÿһ��ͼ������ݴ�С�������ѡ��    ͼ����
    im_addr(i)={sprintf('images/%s/image_%04d.jpg',char(ctg(im_ctg_No(i))),im_id(i))}; %% ���������Ҫ��ʾ��ͼ����Ϣ��·��
end    
end
