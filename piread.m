%�ȵõ��ļ�·����
di=dir('D:\����������ļ�\�����\��������\UCMerced_LandUse\Images\agricultural\*.tif');
%����Ӱ��
for k=1:length(di)
    I(k,:,:)=imread(['D:\����������ļ�\�����\��������\UCMerced_LandUse\Images\agricultural'],di(k).name);
end
