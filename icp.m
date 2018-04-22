function [R, T, e, t] = icp( Y, X, Iy, Ix, n_iter, worst_rejct_ratio, alpha)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name        : icp_v3 
% Description : function a modified Iterative Closest Point (ICP) algorithm
%
%   Input   :   Y - Target Point Cloud
%               X - Reference Point Cloud
%               Iy - Target Image in LAB space
%               Ix - Reference Image in LAB space
%               n_iter - number of iterations of ICP
%               worst_rejct_ratio - Proportion of bad matches to be that 
%                                   should be rejected
%               alpha - Weight for image component in Nearest Neighbor search
%
%   Output  :   R - estimated rotation between point clouds X and Y
%               T - estimated translation
%               e - fitting error at each iteration of ICP
%               t - time taken for each iteration of ICP
%
%   Requirements : The following Matlab Toolboxes are required
%                   1. Statistics and Machine Learning Toolbox
%                   2. Optimization Toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


X_ = X;
Nx = length(X);

e = zeros(n_iter,1);
t = zeros(n_iter,1);

% initial values of
T = zeros(3,1);
R = eye(3,3);

% Estimate normals
Normals = lsqnormest(Y,4);

% KDtree searcher
kdTreeObj = KDTreeSearcher(cat(1,Y,alpha*Iy)');


for i = 1 : n_iter
    tic;
    % Nearest Neighbor search
    [match_idx, dist] = knnsearch(kdTreeObj,cat(1,X_,alpha*Ix)','K',1);
    
     x_valid_flag = true(1, Nx);     
          
     % Reject worst matches
     n_points_to_keep = floor((1 - worst_rejct_ratio)*Nx);
     matched_pairs = find(x_valid_flag);
     [~, idx] = sort(dist);
     x_valid_flag(matched_pairs(idx(n_points_to_keep:end))) = false;
     x_valid_flag(isnan(dist)) = false;
     y_idx = match_idx(x_valid_flag);
     
     
     [Ri,Ti] = Point2Plane_solver(Y(:,y_idx),X_(:,x_valid_flag),Normals(:,y_idx));        
         
     
     % Update parameters
     R = Ri*R;
     T = Ri*T + Ti;
     
     % Update point cloud according to estimated parameters
     X_ = bsxfun(@plus,R * X , T);
     
     % Calculate error
     diff = Y(:,y_idx) - X_(:,x_valid_flag);
     e(i) = sqrt(mean(sum(diff.^2)));
     t(i) = toc;
     
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [R,T] = Point2Plane_solver(q,p,n)
% Function to minimize the Point to Plane loss function
% using Levenberg-Marquardt Optimizer

Rx = @(a)[1     0       0;
          0     cos(a)  -sin(a);
          0     sin(a)  cos(a)];
      
Ry = @(b)[cos(b)    0   sin(b);
          0         1   0;
          -sin(b)   0   cos(b)];
      
Rz = @(g)[cos(g)    -sin(g) 0;
          sin(g)    cos(g)  0;
          0         0       1];

Rot = @(x)Rx(x(1))*Ry(x(2))*Rz(x(3));

% Loss function L = min {[(R*X+T) - Y]*Nrm }
t_fun = @(x,xdata) Rot(x(1:3))*xdata(1:3,:)+repmat(x(4:6),1,length(xdata));
myfun = @(x,xdata) sum( (t_fun(x,xdata) - xdata(4:6,:)) .* xdata(7:9,:));

X = cat(1,p,q,n);
options = optimset('Algorithm', 'levenberg-marquardt');
x = lsqcurvefit(myfun, zeros(6,1), double(X),zeros(1,length(X)), [], [], options);


R = Rot(x(1:3));
T = x(4:6);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function n = lsqnormest(p, k)
% Function to compute normals at each point of the point cloud

m = size(p,2);
n = zeros(3,m);

% Find k-Nearset Neighbors of each point
neighbors = transpose(knnsearch(transpose(p), transpose(p), 'k', k+1));


for i = 1:m
    x = p(:,neighbors(2:end, i));
    p_bar = 1/k * sum(x,2);
    
    % Compute Covariance Matrix
    C = (x - repmat(p_bar,1,k)) * transpose(x - repmat(p_bar,1,k)); 
    
    % Eigen Decomposition
    [V,D] = eig(C);
    
    [~, idx] = min(diag(D)); % choses the smallest eigenvalue
    
    n(:,i) = V(:,idx);   % returns the corresponding eigenvector    
end


