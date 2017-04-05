 I_in = imread('2_15_25_7.jpg');
 I_in = im2double(I_in);
 J_in = I_in;
  
 I_in = rgb2gray(I_in);
 J_in = rgb2gray(J_in);
 
 %I_in = imadjust(I_in); %use imadjust to enhance contrast
 %J_in = imadjust(J_in);
 
 J_rev = 1-J_in; %reverse image
 
 Laplacian=[0 -1 0; -1 4 -1; 0 -1 0];
 %resp = imfilter(I_in, Laplacian); 
 resp = edge(I_in,'Sobel');
 resp2 = imfilter(J_in, Laplacian);
 resp3 = imfilter(J_in, Laplacian);
 resp = double(resp);
 
 auto_corr = xcorr2(resp, resp);

  figure,
  subplot(1,2,1), imshow(resp/max(max(resp))),title('original')
  %subplot(1,2,1), imshow(resp3/max(max(resp3))),title('with inverse');
  subplot(1,2,2), imshow(resp2/max(max(resp2))),title('with imadjust');
  
  figure,
  imshow(auto_corr/max(max(auto_corr))),title('auto corr sobel');
%   
%   figure,
%   imshow(auto_corr3/max(max(auto_corr3))),title('auto corr3');
  
  bdry = size(I_in,1)-30;
  
  auto_corr = auto_corr(bdry:end-bdry, bdry:end-bdry);
  
  max_1 = ordfilt2(auto_corr, 25, true(5));
  max_2 = ordfilt2(auto_corr, 24, true(5)); %24 or 21

  auto_corr(end/2 - 4 : end/2 + 4, end/2 - 4 : end/2+4)=0;
  candidates = find((auto_corr == max_1) & ((max_1 - max_2)>10));%original 70
  
  candidates_val = auto_corr(candidates);

%   cur_max = 0;
%   dx = 0; 
%   dy = 0;
%   offset = size(auto_corr)/2 + 1;
%   for i = 1 : length(candidates)
%     if (candidates_val(i) > cur_max)  
%       [dy , dx] = ind2sub(size(auto_corr), candidates(i)); 
%       dy = dy - offset(1);
%       dx = dx - offset(2);
%     end
%   end
%   c = est_attenuation(I_in, dx, dy);