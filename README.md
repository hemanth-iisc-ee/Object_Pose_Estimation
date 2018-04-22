# Object Pose Estimation 

# Project Objective:
To develop an algorithm to determine the position and orientation of an object at any location in a 3D space using RGBD data.

# Sensor:
I have used the data from a Microsoft Kinect-2.0 sensor for solving this task. This sensor is a device sold by Microsoft with their Xbox gamming device. It consists of a Time-of-Flight (ToF) depth sensor and a RGB camera (RGB+D sensor). 

@ Dataset:
I have used the dataset provided by Alberto Garcia-Garcia (a PhD student in the field of Machine Learning and Computer Vision). The dataset is published for Object Recognition and 3D pose estimation. It contains RGB+D data of 30 objects captured at different poses. The dataset can be down loaded from the following url: https://www.dtic.ua.es/~agarcia/projects/multisensor_dataset

# Assumptions:
1.	The objects are undergoing smooth motion (i.e. a small rigid body transformation between frame intervals).
2.	The objects of interest are segmentable in RGB or equivalent color space using a simple background subtraction module.

