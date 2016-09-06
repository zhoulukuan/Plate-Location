file_path =  'G:\\code\\matlab\\recogniziton\\Blue\\';% 图像文件夹路径
img_path_list = dir(strcat(file_path,'*.jpg'));%获取该文件夹中所有jpg格式的图像
img_num = length(img_path_list);%获取图像总数量
if img_num > 0 %有满足条件的图像
        for j = 1:img_num %逐一读取图像
            %识别图像
            image_name = img_path_list(j).name;% 图像名
            if length(image_name) >= 10
                delete(image_name);
            end
        end
end