function number = recognition(image_name)
%函数功能：识别图像中车牌，计算车牌数量并输出
%输入参数：车牌所在图像的名称
%输出参数：含有的车牌数量
    
	%获取不同颜色车牌数量
    num1 = bbww(image_name);%检测蓝底白字车牌，存储区域，返回检测到的数量，完整形式为num1 = bbww(image_name,0)代表开始检测蓝色时已经输出的车牌数量为0
   % num2 = ybbw(varargin{1},num1);%检测黄底白字车牌，未实现
    
    %总的车牌数量，完整形式为number = num1 + num2 + ...
    number = num1;
end

