images = dir('C:/Users/LIU/Desktop/KinFaceW-II/images/father-son/*.jpg');
for image = images'
    % jpgfile = load(image.name);
    gen_feature(strcat('C:/Users/LIU/Desktop/KinFaceW-II/images/father-son/' , image.name))
end
