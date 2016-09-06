file_path =  'G:\\code\\matlab\\recogniziton\\Blue\\';% 图像文件夹路径
img_path_list = dir(strcat(file_path,'*.jpg'));%获取该文件夹中所有jpg格式的图像
img_num = length(img_path_list);%获取图像总数量
fid = fopen('plate.txt','a+');
a = 0;
if img_num > 0 %有满足条件的图像
          for j = 1:img_num
              image_name = img_path_list(j).name;% 图像名
              if length(image_name) > 8 continue;end
                    time = isDay(image_name);
                    if time == 0
                        a = a + 1;
                    end
               
%               fprintf(fid,'%06.4f',M);
%               fprintf(fid,'\r\n');
          end
end
fclose(fid);
clear file_path img_path_list img_num image_name Blue j%清除变量