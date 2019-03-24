function [VBL_stamp,onset_stamp,KeyIsDown,KeySecs]=ImageSeries(window,windowRect,im_ctg_No,target_ctg_No,fresh_interval,instr_index,T,para_id)
%RSVP
% im_ctg_No: 图像分类编码，分属于不同的图像数据库
% im_id:     图像ID
%global variable:
    %im_addr,image address
%external variables:
    %window:onscreen window index;
    %N:number of images in a single block
%internal variables:
    %im_mtx:image matrix
    %t_index:array of Texture indexs
%output:
global im_addr;global ctg;global N; 
% Bump priority for speed        
	priorityLevel=MaxPriority(window)
    Priority(priorityLevel);
%Prepare Textures for all images in RSVP
for i=1:N
    im_mtx=imread(char(im_addr(i)));
    t_index(i)=Screen(window,'MakeTexture',im_mtx); %所有图像的路径索引
end
    %Preload Textures
success=Screen('PreloadTextures',window,t_index);
if ~success
    warning('Preload Failed');
end
%show '+' fixation 
Screen('DrawTexture',window,instr_index(3));
t0=Screen('Flip', window);
%show of RSVP
    wait_frames=T; %%%60为刷新频率，图像呈现的时间受制于电脑的刷新频率
    VBL_stamp=zeros(1,N+1);onset_stamp=zeros(1,N+1);KeyIsDown=zeros(1,N+1);KeySecs=zeros(1,N+1); %%% 数据保存的临时变量定义
        for i=1:N
            tic;
            tRect=Screen('Rect', t_index(i));
%             ctRect=CenterRect(1.5*tRect, windowRect);
%             ctRect=[windowRect(3)/2-600,windowRect(4)/2-450,windowRect(3)/2+600,windowRect(4)/2+450];
            ctRect=[windowRect(3)/2-250,windowRect(4)/2-250,windowRect(3)/2+250,windowRect(4)/2+250];
            Screen(window,'DrawTexture',t_index(i),tRect,ctRect);
            if i==1
                [VBL_stamp(i),onset_stamp(i)]=Screen('Flip', window,t0+(10*wait_frames-0.5)*fresh_interval);  %% 定义刷新时间间隔
            else
                [VBL_stamp(i),onset_stamp(i)]=Screen('Flip', window,VBL_stamp(i-1)+(wait_frames-0.5)*fresh_interval);  %% 定义刷新时间间隔
            end
            %Cumulative Timing Mode
                %t_stamp(i)=Screen('Flip', window,t0+(wait_frames-0.5)*fresh_interval*i);
                %Screen('Close',t_index(i));
            %Send Trigger            
            if im_ctg_No(i)==target_ctg_No;
%                 outp(hex2dec(para_id),target_ctg_No);
%                 WaitSecs(0.01);
                outp(hex2dec(para_id),1);
            else
%                 outp(hex2dec(para_id),im_ctg_No(i));
%                 WaitSecs(0.01);
                outp(hex2dec(para_id),2);
            end
                outp(hex2dec(para_id),0);
%                 WaitSecs(0.01);
%                 outp(hex2dec(para_id),0);
             %Keyboard Check
             tic;
 %%% T=6  10hz
             while (toc<=0.044&&KeyIsDown(i)==0&&i>=2&&KeyIsDown(i-1)==0)%key board check for 60ms 
                 [KeyIsDown(i),KeySecs(i)]=KbCheck;
                 if (KeyIsDown(i) == 1)
                     WaitSecs(0.01);
                     outp(hex2dec(para_id),3);
                     outp(hex2dec(para_id),0);
                 end
             end
       
        end
    %show 'Data Recording...' Instruction 
    Screen('DrawTexture',window,instr_index(4));
    [VBL_stamp(N+1),onset_stamp(N+1)]=Screen('Flip', window,VBL_stamp(N)+(wait_frames-0.5)*fresh_interval);
    tic
    while (toc<=0.5 && KeyIsDown(N+1)==0 && i>=2 && KeyIsDown(N)==0)%key board check for 500ms
        [KeyIsDown(N+1),KeySecs(N+1)]=KbCheck;
    end
    %t_stamp(N+1)=Screen('Flip', window,t0+(wait_frames-0.5)*fresh_interval*(N+1));
    Screen('Close',t_index);
    Priority(0);
end
% tRect=Screen('Rect', im_index);
% [ctRect, dx, dy]=CenterRect(3*tRect, windowRect);
% Screen(window,'DrawTexture',im_index,tRect,ctRect);
