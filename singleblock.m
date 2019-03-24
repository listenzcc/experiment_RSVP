function DataMat=singleblock(window,windowRect,fresh_interval,instr_index,target_ctg_No,tgt_num,T,para_id)
%Single Block Presentation
%N:number of images in a single block
%target_num:number of target images in a block
%tgt_loc:location of target images in a block(1-2).1.not in first/last 5
%images;2.interval of at least 30 images
global im_addr;global N;
%Data Matrix Preparation
DataMat=cell(N+1,6);
%generate image addresses
im_addr=cell(1,N);
% tgt_num=random('unid',2);　%%20160509修改注释
% tgt_num=4; %%% Target number
tgt_loc=random('unid',N-30,1,tgt_num);

if tgt_num==2
    while abs(tgt_loc(1)-tgt_loc(2))<=20
        tgt_loc=random('unid',N-20,1,tgt_num);
    end
end
if tgt_num==3
    while abs(tgt_loc(2)-tgt_loc(1))<=20 || abs(tgt_loc(2)-tgt_loc(3))<=20 || abs(tgt_loc(3)-tgt_loc(1))<=20 
        tgt_loc=random('unid',N-20,1,tgt_num);
    end
end
if tgt_num==4
    while abs(tgt_loc(1)-tgt_loc(2))<=15 || abs(tgt_loc(1)-tgt_loc(3))<=15 || abs(tgt_loc(1)-tgt_loc(4))<=15 || abs(tgt_loc(2)-tgt_loc(3))<=15 || abs(tgt_loc(2)-tgt_loc(4))<=15 || abs(tgt_loc(3)-tgt_loc(4))<=15
        tgt_loc=random('unid',N-20,1,tgt_num);
    end
end
if tgt_num==5
    while abs(tgt_loc(1)-tgt_loc(2))<=10 || abs(tgt_loc(1)-tgt_loc(3))<=10 || abs(tgt_loc(1)-tgt_loc(4))<=10 || abs(tgt_loc(1)-tgt_loc(5))<=10 || abs(tgt_loc(2)-tgt_loc(3))<=10 || abs(tgt_loc(2)-tgt_loc(4))<=10 || abs(tgt_loc(2)-tgt_loc(5))<=10 || abs(tgt_loc(3)-tgt_loc(4))<=10 || abs(tgt_loc(3)-tgt_loc(5))<=10 || abs(tgt_loc(4)-tgt_loc(5))<=10
        tgt_loc=random('unid',N-20,1,tgt_num);
    end
end
tgt_loc=tgt_loc+10;
[im_ctg_No,im_id]=addr_gen(N,tgt_loc,target_ctg_No);
% 以上完成了图像数据库路径的导入
%Show Text "Press any button to go"
% Screen('DrawTexture',window,instr_index(1));
% Screen('Flip', window);

% Screen('DrawTexture',window,instr_index(7));
% Screen('Flip', window);
% wait for keyboard input
Screen('DrawTexture',window,instr_index(2));
WaitSecs(0.5);
% KbWait %%%%%%%%%%%%%%%%%%%%
%Show Text "Loading..."
Screen('Flip',window);  
%RSVP
[VBL_stamp,onset_stamp,KeyIsDown,KeySecs]=ImageSeries(window,windowRect,im_ctg_No,target_ctg_No,fresh_interval,instr_index,T,para_id);

% %in MATLAB 2008b
% DataMat(1:N,1:2)=mat2cell([im_ctg_No',im_id']);
% DataMat(:,3:6)=mat2cell([VBL_stamp',onset_stamp',KeyIsDown',KeySecs']);
%in MATLAB 2010b
DataMat(1:N,1:2)=mat2cell([im_ctg_No',im_id'],ones(N,1),ones(2,1));
DataMat(:,3:6)=mat2cell([VBL_stamp',onset_stamp',KeyIsDown',KeySecs'],ones(N+1,1),ones(4,1));

end

