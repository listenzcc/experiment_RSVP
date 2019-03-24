clear all
path='C:\Download\DataSet\tainda_new';
cd(path)
% info about distractors & target
% ctg:names of sti mulus image categories
% ctg_size:sizes o f       stimulus image categories
% N:number of images in a single block
format long
global ctg;global ctg_size;global N; global T; 
% ctg={'Target_ship','Nontarget_ship'};%'streetwph'};
ctg={'streetwp_new','streetwop_new'};%'streetwph'};
% ctg_size=[90,1174];%,65];
ctg_size=[56,1344];%,65];
% N=150;
N=100;
% %Parellel Port Preparation
config_io;
%%
para_id='D020';
blk_num=14;
prompt = {'Name','Test time'};
dlg_title = 'Information';
num_lines = 1;
defautanswer = {'',''};
ShowSubjectInfo = inputdlg(prompt,dlg_title,num_lines,defautanswer,'on');

%% xls write Preparation
data_record=cell(N+3,7);
data_record(1,:)={'No.','CategoryNo','ImageId','VBL.stamp','Onset.stamp','PressKey','KeySecs'};
% in MATLAB 2008b
% data_record(2:N+2,1)=mat2cell(1:N+1);
% in MATLAB 2010b
data_record(2:N+2,1)=mat2cell((1:N+1)',ones(N+1,1),1);
% Screen window preparations
screens=Screen('Screens');
screenNumber=max(screens);
% Open a window.  Note the new argument to OpenWindow with value 2,
% specifying the number of buffers to the onscreen window.


[window,windowRect]=Screen('OpenWindow',screenNumber, 0,[],32,2);
fresh_interval=Screen('GetFlipInterval',window);  %%relate to refresh frequency 0.0167s（1s/60）
% Find the color values which correspond to white and black.
white=WhiteIndex(screenNumber);
black=BlackIndex(screenNumber);
%White Background
Screen('FillRect',window, uint8(white));
%Preparation of instructions Textures
for i=1:6
    im_mtx=imread(sprintf('instr%d.jpg',i));
    instr_index(i)=Screen(window,'MakeTexture',im_mtx);
end
Screen('DrawTexture',window,instr_index(5));
Screen('Flip', window);
WaitSecs(2); % 原始0.5
%     KbWait; %%%%%%%%%%%%%%%%%%%%%
%target_ctg_No=1;%target category
%     LearnTarget(window,windowRect,target      _ctg_No);
tgt_num = 4;
temp_data_record=[];
frame=6;
Target_im_mtx=imread(sprintf('Target%d.jpg',2));
Target_index=Screen(window,'MakeTexture',Target_im_mtx);
Screen('DrawTexture',window,Target_index);
Screen('Flip', window);
WaitSecs(2);

T=frame;
msg=sprintf('RSVP speed %1dHz',60/T);
width=RectWidth(Screen(window,'TextBounds',msg));
[x,y]=WindowCenter(window);
Screen('TextSize', window,40);
Screen(window,'DrawText',msg,x-250,y,[0 0 0]);
%                 Screen(window,'DrawText',msg,windowRect(3)/2-width/2,windowRect(4)/2,[0 0 0]);
Screen(window,'Flip');
WaitSecs(1);
KbWait;  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
Screen('DrawTexture',window,instr_index(1));
Screen('Flip', window);
WaitSecs(1);  %%原始为0.5

KbWait;  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for block=1:blk_num
    target_ctg_No=1;%target category
    DataMat= singleblock(window,windowRect,fresh_interval,instr_index,target_ctg_No,tgt_num,T,para_id);
    data_record(2:N+2,2:7)=DataMat;
    data_record(N+3,1:2)={'target category',target_ctg_No};
    ctg_n=cell2mat(DataMat(:,1));  %%% 显示的目标图像所属数据库
    Id=cell2mat(DataMat(:,2));  %%% 显示的目标图像ID
    im_time=cell2mat(DataMat(:,3));  %%% 图像呈现时针
    key=cell2mat(DataMat(:,5));  %%% 键盘控制信息
    key_time=cell2mat(DataMat(:,6)); %%% 键盘控制时间
    
     
    %%%丢失目标程序
    new_type_val=uint8(21*ones(1,100));
    
    temp_i=[];
    key_loc=find(key==1);  %%  按键位置
    tgt_loc=find(ctg_n==target_ctg_No);  %%  目标位置
    
    
    tgt_loc_temp = tgt_loc;
    for key_loc_i=1:length(key_loc)
        for tgt_loc_i=1:length(tgt_loc)
            if key_loc(key_loc_i)-tgt_loc(tgt_loc_i)>=2 && key_loc(key_loc_i)-tgt_loc(tgt_loc_i)<=9;
                new_type_val(tgt_loc(tgt_loc_i))=10; %% 发现目标则为10
                temp_i(tgt_loc_i)=[tgt_loc_i];  %% 目标中靶情况
            end
            
        end
    end
    temp_b=find(temp_i==0); %% 找到丢失目标
    temp_i(temp_b)=[];  %% 保留中靶目标
    tgt_loc_temp(temp_i)=[]; %% 丢失目标位置
    
    a=tgt_loc_temp;
    if (length(a)>0 && (length(a)<tgt_num+1))
        msg=sprintf('You have missed %1d target! Press any key to check out.',length(a));
    else if (length(a)<1)
            msg=sprintf('Wonderful! No target missed! Press any key to continue.');
        end
    end
    width=RectWidth(Screen(window,'TextBounds',msg));
    %         Screen('TextSize', window,30);
    Screen(window,'DrawText',msg,windowRect(3)/2-width/2,windowRect(4)/2,[128 137 128]);
    Screen(window,'Flip');
    WaitSecs(0.3);
     KbWait    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (length(a)>0 )
        for  j=1:length(a)
            addr=sprintf('images/%s/image_%04d.jpg',char(ctg(ctg_n(a(j)))),Id(a(j)));  %% 反找到丢失图片，再呈现，哪一类第几个
            im_mtx=imread(addr);
            index=Screen(window,'MakeTexture',im_mtx);
            tRect=Screen('Rect', index);
            %                 ctRect=CenterRect(1.5*tRect, windowRect);
            ctRect=[windowRect(3)/2-250,windowRect(4)/2-250,windowRect(3)/2+250,windowRect(4)/2+250];
            Screen(window,'DrawTexture',index,tRect,ctRect);
            Screen('Flip', window);
            WaitSecs(0.8);  %原始0.3
            %             KbWait %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
    end 
    %%
    mkdir(strcat(ShowSubjectInfo{1,1},ShowSubjectInfo{2,1}));
    cd(strcat(ShowSubjectInfo{1,1},ShowSubjectInfo{2,1}))
    %             eval(['new_folder=''','target',num2str(i),''';'])
    eval(['new_folder=''',char(ctg(1)),''';'])
    mkdir(new_folder);
    %             eval(['filename = ''','target',num2str(i),'\',num2str(T*1000),'.xls'';'])
    eval(['filename = ''',char(ctg(1)),'\',num2str(60/T),'hz.xls'';'])
    xlswrite(filename,data_record,sprintf('training%d',block));
    
    Screen('DrawTexture',window,instr_index(1));
    Screen('Flip', window);
    KbWait;  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cd(path)
end

Screen('CloseAll')