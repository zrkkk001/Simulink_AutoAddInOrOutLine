% V1.0
% 2023-1-4
% zrkkk
% MATLAB 2015b
model_set=[30,14 ];%参数分别代表模型长和高，可自行修改
int_distance=100;%输入模块和模型的间距，可自行修改
out_distance=100;%输出模块和模型的间距，可自行修改

%% 调节模块大小
a=get(gcbh);
amxl=max(a.Ports)/2*35;

px=(a.Position(1)+a.Position(3))/2;
py=(a.Position(2)+a.Position(4))/2;
a.Position(1)=min(px-amxl*0.618/2,a.Position(1));
a.Position(3)=max(px+amxl*0.618/2,a.Position(3));

a.Position(2)=py-amxl;
a.Position(4)=py+amxl;
set_param(gcb,'Position',a.Position,'Description',[get_param(gcb,'Description') datestr(now,31) ,newline...
    getenv('USERNAME')  newline  newline ]);

%% 搜索本层输入输出信号
all=get(gcbh);%获取目标

Path=all.Path;%目标模块路径
Blocks =all.Blocks;%输入输出模块名称
PortConnectivity=all.PortConnectivity;%输入输出模块数量及点位信息
InportCell = find_system(Path,'SearchDepth','1','BlockType','Inport'); 
OurportCell = find_system(Path,'SearchDepth','1','BlockType','Outport');  %获取本层Outport模块路径

%% 添加输入输出端


a='';
%名称重命名
% for i =1:numel(Blocks)  
% %             Blocks{i,1}= regexprep(Blocks{i,1},'B_','');
%          if regexpi(Blocks{i,1},'T_.*')%阀策略信号、压力目标信号名称统一
%                  Blocks{i,1}= regexprep( Blocks{i,1},'T_','');
%                
%                   Blocks{i,1}=[Blocks{i,1},'_Duration']
%          end 
%               if regexpi(Blocks{i,1},'.*(Duration).*')%阀策略信号、压力目标信号名称统一
%                  Blocks{i,1}= regexprep( Blocks{i,1},'_Duration_','_Duration');
%                  Blocks{i,1}=[Blocks{i,1}(1:2),Blocks{i,1}(end-1:end),Blocks{i,1}(3:end-2)]
%               end 
% end
for i =1:numel(PortConnectivity)  
if PortConnectivity(i).Position(1)==PortConnectivity(1).Position(1)
%  continue
     if PortConnectivity(i).SrcBlock >0
     
      elseif  ismember([Path,'/' ,Blocks{i,1}],InportCell)
          [intnum,intwhee]= ismember([Path,'/' ,Blocks{i,1}],InportCell);
         add_line(Path,[Blocks{i,1},'/1'],[all.Name,'/',PortConnectivity(i).Type],'autorouting','smart');
     elseif  ismember([Path,'/' ,Blocks{i,1}],OurportCell);
        
 else
Blocks{i,1}=[a,Blocks{i,1}];
Inport_handle=add_block('simulink/Ports & Subsystems/In1',[Path,'/' ,Blocks{i,1}]);
   
   
 positiontaype=[-model_set(1)-int_distance -model_set(2)/2 -int_distance model_set(2)/2] ; 
 Inport_position = positiontaype+[PortConnectivity(i).Position, PortConnectivity(i).Position];
   set_param(Inport_handle,'position',Inport_position);
    %连线   
add_line(Path,[Blocks{i,1},'/1'],[all.Name,'/',PortConnectivity(i).Type],'autorouting','smart');
    end
else
   
%      continue
    k=numel(PortConnectivity)-i;
       Blocks{end-k,1}=[a,Blocks{end-k,1}];
     if PortConnectivity(end-k).DstBlock >0
     elseif  ismember([Path,'/' ,Blocks{end-k,1}],OurportCell)
           
          [outtnum,outtwhee]= ismember([Path,'/' ,Blocks{i,1}],OurportCell);
        add_line(Path,[all.Name,'/',PortConnectivity(i).Type],[Blocks{end-k,1},'/1']);
         
     elseif  ismember([Path,'/' ,Blocks{end-k,1}],InportCell)
          
     else

   Outport_handle=add_block('simulink/Ports & Subsystems/Out1',[Path,'/' ,Blocks{end-k,1}]);
 
   
 positiontaype=[out_distance -model_set(2)/2 model_set(1)+out_distance model_set(2)/2] ; 
 Outport_position = positiontaype+[PortConnectivity(i).Position, PortConnectivity(i).Position];
   set_param(Outport_handle,'position',Outport_position);
    %连线
 add_line(Path,[all.Name,'/',PortConnectivity(i).Type],[Blocks{end-k,1},'/1']);
    end
    
end
end
