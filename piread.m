%先得到文件路径名
di=dir('D:\韩潇冰所有文件\韩潇冰\场景数据\UCMerced_LandUse\Images\agricultural\*.tif');
%读入影像
for k=1:length(di)
    I(k,:,:)=imread(['D:\韩潇冰所有文件\韩潇冰\场景数据\UCMerced_LandUse\Images\agricultural'],di(k).name);
end
