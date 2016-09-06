function j = bbww( varargin )
%函数功能：blue-background-white-writings，计算图像中蓝底白字的车牌的数量，并将车牌区域输出
%输入参数：第一个参数为图片名称，第二个参数为起始的车牌数量
%输出参数：j代表蓝底白字的车牌数量
    %获取图像
    f = imread(varargin{1});
    
    %获取颜色区域
    [Blue,temp] = colorDetection(f,1,'area','day');
    [L,num] = bwlabel(Blue,8);
    S = regionprops(L,'basic');
    [S,num] = areaJudge(S,num);

    j = 0; %j = varargin{2}
    for i=1:num
        rec = S(i,:);
        temp = imcrop(f,rec);
        [conveximage,flag] = isPlate(temp,'day'); %进一步判断车牌是否含有车牌
        if flag == 0 continue;end
       
        
        %获得蓝色、边缘点、取蓝色边缘点
        Blue = colorDetection(temp,1,'edge','day');
        edge = colorLP(temp);
        junction = Blue & edge & conveximage;
		%计算车牌区域
        [x,y,width,height,flag] = posCalculation(junction);


        %若车牌存在，则适当放宽阈值，输出图像
        if  flag == 1
            if width < 500 || height < 250
                x = x - width * 0.2;
                width = width * 1.4;
                y = y - height * 0.1;
                height = height * 1.2;
            else
                x = x - width * 0.1;
                width = width * 1.2;
                y = y - height * 0.1;
                height = height * 1.2;
            end
            j = j + 1;
            rec(1) = rec(1) + x;
            rec(2) = rec(2) + y;
            rec(3) = width;
            rec(4) = height;
            temp = imcrop(f,rec);
            name = [varargin{1}(1:4),'_0',num2str(j),'.jpg'];
            imwrite(temp,name,'jpg');
        end
    end
    
    %若未检测到车牌，则进行颜色补偿与夜间检测
    if j == 0
		%使用retinex算法，后续步骤同白天
        f = retinex(f);
        
        %获取颜色区域
        [Blue,temp] = colorDetection(f,1,'area','nig');
        [L,num] = bwlabel(Blue,8);
        S = regionprops(L,'basic');
        [S,num] = areaJudge(S,num);
        for i=1:num
            rec = S(i,:);
            temp = imcrop(f,rec);
            [conveximage,flag] = isPlate(temp,'nig');
            if flag == 0 continue;end

            %获得蓝色、白色、边缘点
            Blue = colorDetection(temp,1,'edge','nig');
            edge = colorLP(temp);

            junction = Blue & edge & conveximage;
            [x,y,width,height,flag] = posCalculation(junction);
            temp = imcrop(f,[x y width height]);


            %若车牌存在，则适当放宽阈值，输出图像
            if  flag == 1
                if width < 500 || height < 250
                    x = x - width * 0.2;
                    width = width * 1.4;
                    y = y - height * 0.1;
                    height = height * 1.2;
                else
                    x = x - width * 0.1;
                    width = width * 1.2;
                    y = y - height * 0.1;
                    height = height * 1.2;
                end
                j = j + 1;
                rec(1) = rec(1) + x;
                rec(2) = rec(2) + y;
                rec(3) = width;
                rec(4) = height;
                temp = imcrop(f,rec);
                name = [varargin{1}(1:4),'_0',num2str(j),'.jpg'];
                imwrite(temp,name,'jpg');
            end
        end
    end
end

