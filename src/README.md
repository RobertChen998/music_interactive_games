# Red Circle Detection using OpenCV

## Overview
This project detects red circles in a video stream using OpenCV. The detected red circles' coordinates are scaled to a defined box and separated into two regions based on the x-axis. The coordinates of the detected red circles are then sent to a serial port.

## Instructions

1. **Define the Detection Box Coordinates:**
   Before running the program, you need to specify the top-left and bottom-right coordinates of the detection box. These coordinates are defined by the variables `x1`, `y1`, `x2`, and `y2` in the script.

   ```python
   # Define the box's top-left and bottom-right coordinates
   x1, y1 = 0, 0
   x2, y2 = 26, 13
   ```
    Running the Program: The program will detect red circles within the defined detection box. It will identify two red points, one in the left half and one in the right half of the box. If no red points are detected in a region, the coordinates (-1, -1) will be sent for that region.

    Output: The detected coordinates are printed and sent to the serial port in the format (x1, y1), (x2, y2), where (x1, y1) represents the coordinates of the red point in the left region and (x2, y2) represents the coordinates of the red point in the right region.


    Exiting the Program: The program will continue to run and detect red circles until the 'q' key is pressed. Upon exiting, the camera and serial port resources will be released.

## Dependencies
    Python 3.x
    OpenCV
    NumPy
    PySerial
Make sure to install the required dependencies before running the program:
```
pip install opencv-python numpy pyserial
```
## Notes
Modify the serial port number according to your own situation.
Adjust the camera resolution and frame rate settings as needed.
Ensure the detection box coordinates are correctly set for accurate detection.
