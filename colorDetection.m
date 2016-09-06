function Block = colorDetection(varargin)
%函数功能：检测图像中特定颜色的区域
%输入参数：
%第一个参数-待检测的RGB图像
%第二个参数-待检测颜色，1为蓝色，2为白色
%第三个参数-检测区域(area)还是非区域(edge)
%第四个参数-检测时间是白天(day)还是夜晚(nig)
%输出参数：Block-二值图像，图像中值为1的点对应相应色块
	
    %格式转换
    f = im2double(varargin{1}); 
    f = rgb2hsv(f);
    
    %转化为HSV空间
    H = f(:,:,1) * 360;
    S = f(:,:,2);
    V = f(:,:,3);
    [M,N]=size(H);

    %颜色筛选
    colour = varargin{2};
    choice = varargin{3};
    time = varargin{4};
    if time == 'day' %白天参数
        if choice == 'area' %区域参数
            switch colour
                case 1
                    H1 = ones(M,N) * 240;
                    S1 = ones(M,N);
                    V1 = ones(M,N);
                    D = (S.*cos(H*pi/180) - S1.*cos(H1*pi/180)).^2 + (S.*(sin(H*pi/180)) - S1.*sin(H1*pi/180)).^2 + (V - V1).^2;
                    Block = (1 - sqrt(D) / sqrt(5)) > 0.6 & S > 0.2 & V > 0.3;
            end
        else	%非区域参数
            switch colour	
                case 1
                    H1 = ones(M,N) * 240;
                    S1 = ones(M,N);
                    V1 = ones(M,N);
                    D = (S.*cos(H*pi/180) - S1.*cos(H1*pi/180)).^2 + (S.*(sin(H*pi/180)) - S1.*sin(H1*pi/180)).^2 + (V - V1).^2;
                    Block = (1 - sqrt(D) / sqrt(5)) > 0.65 & S > 0.25 & V > 0.35;
                case 2
                    Block = S < 0.3 & V > 0.7;
            end
        end
    else            %夜晚参数
        if choice == 'area' %区域参数
            switch colour
                case 1
                    H1 = ones(M,N) * 240;
                    S1 = ones(M,N);
                    V1 = ones(M,N);
                    D = (S.*cos(H*pi/180) - S1.*cos(H1*pi/180)).^2 + (S.*(sin(H*pi/180)) - S1.*sin(H1*pi/180)).^2 + (V - V1).^2;
                    Block = (1 - sqrt(D) / sqrt(5)) > 0.55 & S > 0.2;
            end
        else	%非区域参数
            switch colour
                case 1
                    H1 = ones(M,N) * 240;
                    S1 = ones(M,N);
                    V1 = ones(M,N);
                    D = (S.*cos(H*pi/180) - S1.*cos(H1*pi/180)).^2 + (S.*(sin(H*pi/180)) - S1.*sin(H1*pi/180)).^2 + (V - V1).^2;
                    Block = (1 - sqrt(D) / sqrt(5)) > 0.55 & S > 0.2;
                case 2
                    Block = S < 0.3 & V > 0.7;
            end
        end
    end
    
    %是否需要区域操作
    if choice == 'area'
		%形态学操作，删除小区域，进行膨胀，再删除一次不够大的区域
        Block = bwareaopen(Block,50);
        
        a = ceil(N / 50);
        p = ones(1,a);
        Block = imdilate(Block,p);
        
        Block = bwareaopen(Block,ceil(M*N / 2500));
    end
end

