function [conveximage,flag] = isPlate( image,time )
%函数功能：计算车牌中是否可能含有车牌
%输入参数：image-原图像，time-'day'或'nig'，代表白天或者夜晚
%输出参数：flag-是否可能含有车牌，conveximage-可能含有车牌区域的最小凸外接多边形

	%计算蓝色点所占比例是否满足条件
    Blue = colorDetection(image,1,'area',time);
    if sum(sum(Blue)) < size(Blue,1) * size(Blue,2) * 0.22 
        conveximage = Blue & 0;
        flag = 0;
        return;
    end
    [L,num] = bwlabel(Blue,8);
    
	%反复进行膨胀操作，直到蓝色区域连成一体
    while (num ~= 1)
        Blue = imdilate(Blue,ones(5));
        [L,num] = bwlabel(Blue,8);
    end
    Blue = imfill(Blue,'holes');
    [L,num] = bwlabel(Blue,8);
    
	%获取蓝色区域，判断其占凸多边形的比例是否满足条件
    S = regionprops(Blue,'all');
    hull = S(1).ConvexHull;
    conveximage = roipoly(image,hull(:,1),hull(:,2));
    square = sum(sum(conveximage));
    if S(1).Area < square * 0.6 
        flag = 0;
    else
        flag = 1;
    end
end

