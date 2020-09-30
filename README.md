# Object Pose Estimation 

# Project Objective:
To develop an algorithm to determine the position and orientation of an object at any location in a 3D space using RGBD data.

# Sensor:
Microsoft Kinect-2.0 sensor, It consists of a Time-of-Flight (ToF) depth sensor and a RGB camera (RGB+D sensor). 

# Dataset:
Using dataset provided by Alberto Garcia-Garcia (a PhD student in the field of Machine Learning and Computer Vision). The dataset is published for Object Recognition and 3D pose estimation. It contains RGB+D data of 30 objects captured at different poses. The dataset can be downloaded from the following url: https://www.dtic.ua.es/~agarcia/projects/multisensor_dataset

# Assumptions:
1.	The objects are undergoing smooth motion (i.e. a small rigid body transformation between frame intervals).
2.	The objects of interest are segmentable in RGB or equivalent color space using a simple background subtraction module.

# Output Description:

![image](https://user-images.githubusercontent.com/3444740/39092242-42c397c4-4627-11e8-8de8-4b6f82e8ae5d.png)

The output is an RGB image with mutually perpendicular x,y and z axes overlaid on the RGB image. The orientation of these axes is indicative of the objects pose. The direction of the z-axis for the very first frame coincides with the orientation of the RGB camera (perpendicular to the image plane).

# Algorithm Description:
Iterative Closest Point (ICP) is an iterative algorithm used for aligning two 3D point clouds. I have used the ICP algorithm for estimating the position and pose change between two consecutive frames. In its simplest form ICP each iteration of the algorithm consists of the following steps.

1. For every point in point cloud ![](https://latex.codecogs.com/gif.latex?X) compute the closest point in ![](https://latex.codecogs.com/gif.latex?Y)
  
2. Compute a rotation matrix ![](https://latex.codecogs.com/gif.latex?R) and translation vector ![](https://latex.codecogs.com/gif.latex?T) such that following error metric decreases.
  
      ![](https://latex.codecogs.com/gif.latex?error%20%3D%20%5Csum_i%5Cleft%20%5C%7C%20%28X_iR&plus;T%29%29%20-%20Y_i%5Cright%20%5C%7C_2%5E2)
  
3. Apply the transformation ![](https://latex.codecogs.com/gif.latex?X%27%20%3D%20RX&plus;T)
  
4. Terminate when the error cannot be further reduced (or after a fixed number of iterations)
  
The algorithm described above is called the Point-To-Point version of ICP. I have used an alternate version of ICP, it is known as Point-to-Plane ICP wherein the error function is modified as follows:

      ![](https://latex.codecogs.com/gif.latex?error%3D%5Csum_i%20%28%28RX_i&plus;T%29%20-%20Y_i%29%5Ceta_i)

Where ![](https://latex.codecogs.com/gif.latex?%5Ceta_i) represents the normal for each data point in the point cloud ![](https://latex.codecogs.com/gif.latex?Y).

k-Dimensional Tree (KDTree) data structure is used to speed up the first step (finding closest points) of the ICP algorithm. Generally, KDTree are applied on the 3D coordinates only but I have modified to consider the color component of the object. I have used a 6-dimensional KDTree, three for 3D position of a point and an additional three for the Lab representation of each pixel (Lab color space is widely considered to be resilient to illumination changes). Levenberg–Marquardt algorithm is used to minimize the error function.

# Software Requirements:
The following software are required for running the demo.
1.	Matlab R2016b (or >)
2.	Matlab: Computer Vision System Toolbox
3.	Matlab:  Statistics and Machine Learning Toolbox
4.	Matlab:  Otpimization Toobox

# Instructions:
1. Clone Repository
2.	Start Matlab
3.	Change current working to the location where the files were unzipped
4.	Type ‘demo’ at the command prompt.
5.	For more results download the dataset (url: https://www.dtic.ua.es/~agarcia/projects/multisensor_dataset) and unzip the files into the data folder. In file *demo.m* change the input data path at line-no: 9 (data_dir = './data/taz-primesense/';).

# Refrences:
1. A method for registration of 3-D shapes, Besl, Paul J. and McKay, Neil D., IEEE Trans. Pattern Analysis and Machine Intelligence (PAMI), February 1992.

