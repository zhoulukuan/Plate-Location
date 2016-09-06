function [Area,m] = areaJudge(S,num) 
%函数功能：对区域是否可能存在车牌进行判断，将相似的区域进行区域归并
%传入参数：num-区域数，S-使用regionprops获得的区域数据结构体
%返回参数：m-区域数，Area-区域的矩形数据多维数组，每维的四个数据代表一个数据（x,y,width,height）

	%区域数量过小的情况
    if num < 1 
        m = 0;
        Area = [0 0 0 0];
        return;
    end
    Area = zeros(num,4);
    if num == 1
        m = 1;
        Area(1,:) = S(1,1).BoundingBox;
        return;
    end
    
	%区域数量较多，先存入第一个，从后续开始处理
    m = 1;
    Area(1,1) = S(1,1).BoundingBox(1);
    Area(1,2) = S(1,1).BoundingBox(2);
    Area(1,3) = S(1,1).BoundingBox(3) + S(1,1).BoundingBox(1);
    Area(1,4) = S(1,1).BoundingBox(4) + S(1,1).BoundingBox(2);
    for i=2:num
        rec = S(i,1).BoundingBox;
        rec(3) = rec(1) + rec(3);
        rec(4) = rec(2) + rec(4);
        flag = 0;	%用来记录数据是否被存入
        %区域归并
        for j=1:m
%           若区域包含关系，则不考虑过大的区域
%             if rec(1) > Area(j,1) & rec(2) > Area(j,2) & rec(3) < Area(j,3) & rec(4) < Area(j,4) 
%                if rec(3)-rec(1) > 100 & rec(4)-rec(2) > 50 & (rec(3)-rec(1)) / (rec(4)-rec(2)) > 1.2 & (rec(3)-rec(1)) / (rec(4)-rec(2)) < 6
%                    flag = 1;
%                    Area(j,:) = rec;
%                end
%             elseif rec(1) < Area(j,1) & rec(2) < Area(j,2) & rec(3) < Area(j,3) & rec(4) < Area(j,4)
%                if Area(j,3)-Area(j,1) > 100 & Area(j,4)-Area(j,2) > 50 & (Area(j,3)-Area(j,1)) / (Area(j,4)-Area(j,2)) > 1.2 &  (Area(j,3)-Area(j,1)) / (Area(j,4)-Area(j,2)) < 6
%                    flag = 1;
%                end
               
               
            %若区域相似度高，则进行归并
            if ~(rec(4)<Area(j,2) | rec(2)>Area(j,4)) 
                if rec(2) > Area(j,2) & rec(4) < Area(j,4) 	%计算垂直方向的重合宽度
                    overlay = rec(4) - rec(2);
                elseif rec(2) < Area(j,2) & rec(4) > Area(j,4)
                    overlay = Area(j,4) - Area(j,2);
                else
                    overlay = min(abs(Area(j,4)-rec(2)),abs(Area(j,2)-rec(4)));
                end
                
                distance = max(Area(j,1)-rec(3),rec(1)-Area(j,3));	%水平距离
                k1 = (rec(3)-rec(1)) / (rec(4)-rec(2));
                k2 = (Area(j,3)-Area(j,1)) / (Area(j,4)-Area(j,2));
				%归并条件，满足下合并为一个区域
                if overlay/(rec(4)-rec(2)) > 0.8 & overlay/(Area(j,4)-Area(j,2)) > 0.8 & distance < min(min((rec(3)-rec(1)),(Area(j,3)-Area(j,1))),30) * 1.5 & (k1 < 1.5 | k2 < 1.5)
                    flag = 1;
                    Area(j,1) = min(Area(j,1),rec(1));
                    Area(j,2) = min(Area(j,2),rec(2));
                    Area(j,3) = max(Area(j,3),rec(3));
                    Area(j,4) = max(Area(j,4),rec(4));
                end
           end
        end
        
		%不满足归并条件且长宽比合适则存入数组
        if flag == 0 & rec(3)-rec(1) > 40 & rec(4)-rec(2) > 12
            m = m+1;
            Area(m,:) = rec;
        end
    end
	
	%数组转化成(x,y,width,height)的格式
    Area(:,3) = Area(:,3) - Area(:,1);
    Area(:,4) = Area(:,4) - Area(:,2);
end