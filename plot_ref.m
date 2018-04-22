function  plot_ref( I, img_cords, fig_no)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name        : plot_ref 
% Description : function to plot x,y,z axis on image
%
%   Input   :   I = image
%               img_cords = coordinates of reference on image
%               fig_no = figure number
%   Output  :   none
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[r,~,~] = size(I);

figure(fig_no);imshow(I);    
figure(fig_no);line([img_cords(1,1) img_cords(1,2)],r - [img_cords(2,1) img_cords(2,2)],'Color','r','LineWidth',3);
figure(fig_no);line([img_cords(1,1) img_cords(1,3)],r -[img_cords(2,1) img_cords(2,3)],'Color','g','LineWidth',3);
figure(fig_no);line([img_cords(1,1) img_cords(1,4)],r -[img_cords(2,1) img_cords(2,4)],'Color','b','LineWidth',3);
figure(fig_no);text(img_cords(1,1),r - img_cords(2,1),'p','FontSize',14);
figure(fig_no);text(img_cords(1,2),r - img_cords(2,2),'x','FontSize',14);
figure(fig_no);text(img_cords(1,3),r - img_cords(2,3),'y','FontSize',14);
figure(fig_no);text(img_cords(1,4),r - img_cords(2,4),'z','FontSize',14);
figure(fig_no);drawnow;
    
end

