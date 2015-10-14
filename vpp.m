%% 计算家长线调度曲线

for i=1:24
    mpc = case_cm;
    for j=1:36 %节点负荷
        mpc.bus(loadPos(j),3) = loadMatrix(j,i);
        mpc.bus(loadPos(j),4) =  mpc.bus(loadPos(j),3)*0.1;
    end
    for j=1:7 %机组出力
        mpc.gen(j,2) = genP(j,i);
        mpc.gen(j,3) = genQ(j,i);
    end
    mpc.bus(11,2) = 3; % 长兴设为平衡节点
    mpc.gen(8,2) = 100; % 燃机出力
    mpc.gen(1,2) = mpc.gen(1,2)-100; % 海门设为一个较小定值
    mpc.branch(:,5) = 0; % 暂不考虑电纳，消除线路充电功率影响
    results = runpf(mpc);
    cxP(i) = results.gen(2,2);
end
%% 家长线调度曲线作图
x = 1:24;
y = cxP;
figure
plot(x,y)
xlabel('时间(h)')
ylabel('调度曲线(MW)')

%% 风功率不足调联络线
for i=1:24
    mpc = case_cm;
    for j=1:36 %节点负荷
        mpc.bus(loadPos(j),3) = loadMatrix(j,i);
        mpc.bus(loadPos(j),4) =  mpc.bus(loadPos(j),3)*0.1;
    end
    for j=1:7 %机组出力
        mpc.gen(j,2) = genP(j,i);
        mpc.gen(j,3) = genQ(j,i);
    end
    mpc.bus(11,2) = 3; % 长兴设为平衡节点
    mpc.gen([3,5,6,7],2) = mpc.gen([3,5,6,7],2)*0.8;%风功率降低
    mpc.gen(8,2) = 100; % 燃机出力
    mpc.gen(1,2) = mpc.gen(1,2)-100;% 海门设为一个较小定值
    mpc.branch(:,5) = 0; % 暂不考虑电纳，消除线路充电功率影响
    results = runpf(mpc);
    cxPwindL(i) = results.gen(2,2);
end
%% 风功率不足家长线调度曲线作图
x = 1:24;
y1 = cxP;
y2 = cxPwindL;
figure
plot(x,y1,x,y2)
xlabel('时间(h)')
ylabel('调度曲线(MW)')

%% 风功率不足调燃机
for i=1:24
    mpc = case_cm;
    for j=1:36 %节点负荷
        mpc.bus(loadPos(j),3) = loadMatrix(j,i);
        mpc.bus(loadPos(j),4) =  mpc.bus(loadPos(j),3)*0.1;
    end
    for j=1:7 %机组出力
        mpc.gen(j,2) = genP(j,i);
        mpc.gen(j,3) = genQ(j,i);
    end
    mpc.gen(2,2) = cxP(i); %长兴设为调度功率
    mpc.bus(111,2) = 3; % 燃机设为平衡节点
    mpc.gen([3,5,6,7],2) = mpc.gen([3,5,6,7],2)*0.8;%风功率降低
    mpc.gen(1,2) = mpc.gen(1,2)-100;% 海门设为一个较小定值
    mpc.branch(:,5) = 0; % 暂不考虑电纳，消除线路充电功率影响
    results = runpf(mpc);
    rjPwindL(i) = results.gen(8,2);
end
%% 风功率不足燃机出力曲线作图
x = 1:24;
y1 = zeros(1,24)+100;
y2 = rjPwindL;
figure
plot(x,y1,x,y2)
xlabel('时间(h)')
ylabel('燃机曲线(MW)')

%% 风功率不足经济效益
% 备用机组额外成本
costRes = sum(cxPwindL-cxP)*1000*0.8;
% 燃机额外成本
costGas = sum(rjPwindL-100)*1000*0.5;
%经济效益
costDif = costRes-costGas;
%% 风功率过高调燃机
for i=1:24
    mpc = case_cm;
    for j=1:36 %节点负荷
        mpc.bus(loadPos(j),3) = loadMatrix(j,i);
        mpc.bus(loadPos(j),4) =  mpc.bus(loadPos(j),3)*0.1;
    end
    for j=1:7 %机组出力
        mpc.gen(j,2) = genP(j,i);
        mpc.gen(j,3) = genQ(j,i);
    end
    mpc.gen(2,2) = cxP(i); %长兴设为调度功率
    mpc.bus(111,2) = 3; % 燃机设为平衡节点
    mpc.gen([3,5,6,7],2) = mpc.gen([3,5,6,7],2)*1.2;%风功率升高
    mpc.gen(1,2) = mpc.gen(1,2)-100;% 海门设为一个较小定值
    mpc.branch(:,5) = 0; % 暂不考虑电纳，消除线路充电功率影响
    results = runpf(mpc);
    rjPwindH(i) = results.gen(8,2);
end
%% 风功率过高燃机出力曲线作图
x = 1:24;
y1 = zeros(1,24)+100;
y2 = rjPwindH;
figure
plot(x,y1,x,y2)
xlabel('时间(h)')
ylabel('燃机曲线(MW)')
%% 风功率过高低碳效益
% 燃机减少的碳排放
carbonGas = sum(100-rjPwindH)*1000*0.4;
%% 风功率过高调联络线
for i=1:24
    mpc = case_cm;
    for j=1:36 %节点负荷
        mpc.bus(loadPos(j),3) = loadMatrix(j,i);
        mpc.bus(loadPos(j),4) =  mpc.bus(loadPos(j),3)*0.1;
    end
    for j=1:7 %机组出力
        mpc.gen(j,2) = genP(j,i);
        mpc.gen(j,3) = genQ(j,i);
    end
    mpc.bus(11,2) = 3; % 长兴设为平衡节点
    mpc.gen([3,5,6,7],2) = mpc.gen([3,5,6,7],2)*1.2;%风功率升高
    mpc.gen(8,2) = 100; % 燃机出力
    mpc.gen(1,2) = mpc.gen(1,2)-100;% 海门设为一个较小定值
    mpc.branch(:,5) = 0; % 暂不考虑电纳，消除线路充电功率影响
    results = runpf(mpc);
    cxPwindH(i) = results.gen(2,2);
end
%% 风功率过高家长线调度曲线作图
x = 1:24;
y1 = cxP;
y2 = cxPwindH;
figure
plot(x,y1,x,y2)
xlabel('时间(h)')
ylabel('调度曲线(MW)')
%% 风功率过高经济效益
% 风电导致联络线功率偏差惩罚
punWind = sum(cxP-cxPwindH)*1000*0.3*0.3;


%% 负荷曲线
x = 1:24;
y = sum(loadMatrix);
figure
plot(x,y)
xlabel('时间(h)')
ylabel('总负荷(MW)')
%% 风机总出力曲线
x = 1:24;
y1 = genP(3,:)+genP(5,:)+genP(6,:)+genP(7,:);
y2 = y1*1.2;
figure
plot(x,y1,x,y2,':')
xlabel('时间(h)')
ylabel('风电出力(MW)')
