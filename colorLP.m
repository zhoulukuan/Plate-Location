function image = colorLP(origin)
%函数功能：使用colorLP算子检测图像边缘
%输入参数：原始图像
%输出参数：检测到的边缘图像，为二值图像

	%获取图像各方向分量
    f = im2double(origin);
    R = f(:,:,1);
    G = f(:,:,2);
    B = f(:,:,3);
    
	%计算colorLP算子
    w1 = [-1 0 1;0 0 0;0 0 0];
    w2 = [0 0 0;-1 0 1;0 0 0];
    w3 = [0 0 0;0 0 0;-1 0 1];
    g = stdfilt(G,ones(3));
    b = stdfilt(B,ones(3));
    
    R1 = imfilter(R,w1,'replicate');
    G1 = g.*imfilter(G,w1,'replicate');
    B1 = b.*imfilter(B,w1,'replicate');
    
    R2 = imfilter(R,w2,'replicate');
    G2 = g.*imfilter(G,w2,'replicate');
    B2 = b.*imfilter(B,w2,'replicate');
    
    R3 = imfilter(R,w3,'replicate');
    G3 = g.*imfilter(G,w3,'replicate');
    B3 = b.*imfilter(B,w3,'replicate');
    
    image = sqrt(R1.^2 + G1.^2 + B1.^2) + sqrt(R2.^2 + G2.^2 + B2.^2) + sqrt(R3.^2 + G3.^2 + B3.^2);
    
	%OTSU二值化
	T = graythresh(image);
    image = im2bw(image,T);
end

