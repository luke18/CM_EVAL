%% ����ҳ��ߵ�������

for i=1:24
    mpc = case_cm;
    for j=1:36 %�ڵ㸺��
        mpc.bus(loadPos(j),3) = loadMatrix(j,i);
        mpc.bus(loadPos(j),4) =  mpc.bus(loadPos(j),3)*0.1;
    end
    for j=1:7 %�������
        mpc.gen(j,2) = genP(j,i);
        mpc.gen(j,3) = genQ(j,i);
    end
    mpc.bus(11,2) = 3; % ������Ϊƽ��ڵ�
    mpc.gen(8,2) = 100; % ȼ������
    mpc.gen(1,2) = mpc.gen(1,2)-100; % ������Ϊһ����С��ֵ
    mpc.branch(:,5) = 0; % �ݲ����ǵ��ɣ�������·��繦��Ӱ��
    results = runpf(mpc);
    cxP(i) = results.gen(2,2);
end
%% �ҳ��ߵ���������ͼ
x = 1:24;
y = cxP;
figure
plot(x,y)
xlabel('ʱ��(h)')
ylabel('��������(MW)')

%% �繦�ʲ����������
for i=1:24
    mpc = case_cm;
    for j=1:36 %�ڵ㸺��
        mpc.bus(loadPos(j),3) = loadMatrix(j,i);
        mpc.bus(loadPos(j),4) =  mpc.bus(loadPos(j),3)*0.1;
    end
    for j=1:7 %�������
        mpc.gen(j,2) = genP(j,i);
        mpc.gen(j,3) = genQ(j,i);
    end
    mpc.bus(11,2) = 3; % ������Ϊƽ��ڵ�
    mpc.gen([3,5,6,7],2) = mpc.gen([3,5,6,7],2)*0.8;%�繦�ʽ���
    mpc.gen(8,2) = 100; % ȼ������
    mpc.gen(1,2) = mpc.gen(1,2)-100;% ������Ϊһ����С��ֵ
    mpc.branch(:,5) = 0; % �ݲ����ǵ��ɣ�������·��繦��Ӱ��
    results = runpf(mpc);
    cxPwindL(i) = results.gen(2,2);
end
%% �繦�ʲ���ҳ��ߵ���������ͼ
x = 1:24;
y1 = cxP;
y2 = cxPwindL;
figure
plot(x,y1,x,y2)
xlabel('ʱ��(h)')
ylabel('��������(MW)')

%% �繦�ʲ����ȼ��
for i=1:24
    mpc = case_cm;
    for j=1:36 %�ڵ㸺��
        mpc.bus(loadPos(j),3) = loadMatrix(j,i);
        mpc.bus(loadPos(j),4) =  mpc.bus(loadPos(j),3)*0.1;
    end
    for j=1:7 %�������
        mpc.gen(j,2) = genP(j,i);
        mpc.gen(j,3) = genQ(j,i);
    end
    mpc.gen(2,2) = cxP(i); %������Ϊ���ȹ���
    mpc.bus(111,2) = 3; % ȼ����Ϊƽ��ڵ�
    mpc.gen([3,5,6,7],2) = mpc.gen([3,5,6,7],2)*0.8;%�繦�ʽ���
    mpc.gen(1,2) = mpc.gen(1,2)-100;% ������Ϊһ����С��ֵ
    mpc.branch(:,5) = 0; % �ݲ����ǵ��ɣ�������·��繦��Ӱ��
    results = runpf(mpc);
    rjPwindL(i) = results.gen(8,2);
end
%% �繦�ʲ���ȼ������������ͼ
x = 1:24;
y1 = zeros(1,24)+100;
y2 = rjPwindL;
figure
plot(x,y1,x,y2)
xlabel('ʱ��(h)')
ylabel('ȼ������(MW)')

%% �繦�ʲ��㾭��Ч��
% ���û������ɱ�
costRes = sum(cxPwindL-cxP)*1000*0.8;
% ȼ������ɱ�
costGas = sum(rjPwindL-100)*1000*0.5;
%����Ч��
costDif = costRes-costGas;
%% �繦�ʹ��ߵ�ȼ��
for i=1:24
    mpc = case_cm;
    for j=1:36 %�ڵ㸺��
        mpc.bus(loadPos(j),3) = loadMatrix(j,i);
        mpc.bus(loadPos(j),4) =  mpc.bus(loadPos(j),3)*0.1;
    end
    for j=1:7 %�������
        mpc.gen(j,2) = genP(j,i);
        mpc.gen(j,3) = genQ(j,i);
    end
    mpc.gen(2,2) = cxP(i); %������Ϊ���ȹ���
    mpc.bus(111,2) = 3; % ȼ����Ϊƽ��ڵ�
    mpc.gen([3,5,6,7],2) = mpc.gen([3,5,6,7],2)*1.2;%�繦������
    mpc.gen(1,2) = mpc.gen(1,2)-100;% ������Ϊһ����С��ֵ
    mpc.branch(:,5) = 0; % �ݲ����ǵ��ɣ�������·��繦��Ӱ��
    results = runpf(mpc);
    rjPwindH(i) = results.gen(8,2);
end
%% �繦�ʹ���ȼ������������ͼ
x = 1:24;
y1 = zeros(1,24)+100;
y2 = rjPwindH;
figure
plot(x,y1,x,y2)
xlabel('ʱ��(h)')
ylabel('ȼ������(MW)')
%% �繦�ʹ��ߵ�̼Ч��
% ȼ�����ٵ�̼�ŷ�
carbonGas = sum(100-rjPwindH)*1000*0.4;
%% �繦�ʹ��ߵ�������
for i=1:24
    mpc = case_cm;
    for j=1:36 %�ڵ㸺��
        mpc.bus(loadPos(j),3) = loadMatrix(j,i);
        mpc.bus(loadPos(j),4) =  mpc.bus(loadPos(j),3)*0.1;
    end
    for j=1:7 %�������
        mpc.gen(j,2) = genP(j,i);
        mpc.gen(j,3) = genQ(j,i);
    end
    mpc.bus(11,2) = 3; % ������Ϊƽ��ڵ�
    mpc.gen([3,5,6,7],2) = mpc.gen([3,5,6,7],2)*1.2;%�繦������
    mpc.gen(8,2) = 100; % ȼ������
    mpc.gen(1,2) = mpc.gen(1,2)-100;% ������Ϊһ����С��ֵ
    mpc.branch(:,5) = 0; % �ݲ����ǵ��ɣ�������·��繦��Ӱ��
    results = runpf(mpc);
    cxPwindH(i) = results.gen(2,2);
end
%% �繦�ʹ��߼ҳ��ߵ���������ͼ
x = 1:24;
y1 = cxP;
y2 = cxPwindH;
figure
plot(x,y1,x,y2)
xlabel('ʱ��(h)')
ylabel('��������(MW)')
%% �繦�ʹ��߾���Ч��
% ��絼�������߹���ƫ��ͷ�
punWind = sum(cxP-cxPwindH)*1000*0.3*0.3;


%% ��������
x = 1:24;
y = sum(loadMatrix);
figure
plot(x,y)
xlabel('ʱ��(h)')
ylabel('�ܸ���(MW)')
%% ����ܳ�������
x = 1:24;
y1 = genP(3,:)+genP(5,:)+genP(6,:)+genP(7,:);
y2 = y1*1.2;
figure
plot(x,y1,x,y2,':')
xlabel('ʱ��(h)')
ylabel('������(MW)')
