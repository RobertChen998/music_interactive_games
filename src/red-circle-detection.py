import numpy as np
import cv2
import serial
import time
import struct

# ================ define the box's top-left and bottom-right coordinates ================ 
x1, y1 = 0, 0
x2, y2 = 26, 13

# init serial port
try:
# ================ modify the port number according to your own situation ================
    ser = serial.Serial(
        port='COM1',         
        baudrate=115200,     
        bytesize=serial.EIGHTBITS,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        timeout=1            
    )
    print("Serial port initialized")
except Exception as e:
    print(f"Error initializing serial port: {e}")
    exit()

# init camera
#cap = cv2.VideoCapture(0)
cap = cv2.VideoCapture(1) # 1 is for usb camera
if not cap.isOpened():
    print("Camera is not opened, please check the connection.")
    exit()

# ========= modify the resolution and frame rate according to your own situation ==========
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
cap.set(cv2.CAP_PROP_FPS, 30)

while True:
    ret, captured_frame = cap.read()
    if not ret:
        print("Can't receive frame, exiting...")
        break

    output_frame = captured_frame.copy()

    captured_frame_bgr = cv2.cvtColor(captured_frame, cv2.COLOR_BGRA2BGR)
    captured_frame_bgr = cv2.medianBlur(captured_frame_bgr, 3)
    # convert to Lab color space
    captured_frame_lab = cv2.cvtColor(captured_frame_bgr, cv2.COLOR_BGR2Lab)
    captured_frame_lab_red = cv2.inRange(
        captured_frame_lab, 
        np.array([20, 150, 150]), 
        np.array([190, 255, 255])
    )
    captured_frame_lab_red = cv2.GaussianBlur(captured_frame_lab_red, (5, 5), 2, 2)
    circles = cv2.HoughCircles(
        captured_frame_lab_red, 
        cv2.HOUGH_GRADIENT, 
        dp=1, 
        minDist=captured_frame_lab_red.shape[0] / 8, 
        param1=100, 
        param2=18, 
        minRadius=5, 
        maxRadius=60
    )

    red_points = []

    if circles is not None:
        circles = np.round(circles[0, :]).astype("int")
        for (x, y, r) in circles:
            # Draw detected circles and their centers
            cv2.circle(output_frame, (x, y), r, (0, 255, 0), 2)
            cv2.circle(output_frame, (x, y), 2, (0, 0, 255), 3)
            cv2.putText(output_frame, f"({x},{y})", (x - 10, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 1)
            
            # Scale the coordinates back to the defined box (x1, y1) -> (x2, y2)
            scaled_x = int((captured_frame.shape[1] - x - x1) * (x2 - x1) / captured_frame.shape[1])
            scaled_y = int((y - y1) * (y2 - y1) / captured_frame.shape[0])
            red_points.append((scaled_x, scaled_y))

        # Separate red points into two regions based on x-axis
        region1_point = (-1, -1)
        region2_point = (-1, -1)

        for point in red_points:
            if point[0] <= ((x2-x1) // 2):  # Points in the left region
                region1_point = point
            else:  # Points in the right region
                region2_point = point

        # Print concatenated coordinates and send to serial port
        print(f"Region1: {region1_point}, Region2: {region2_point}")
        # data = f"{region1_point[0]},{region1_point[1]},{region2_point[0]},{region2_point[1]}\n"
        data = struct.pack('bbbb', region1_point[0], region1_point[1], region2_point[0], region2_point[1])
        ser.write(data) 
    # Display the output frame with detected red points
    cv2.imshow('Red Points Detection', output_frame)

    # Exit on pressing 'q'
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Release resources
cap.release()
cv2.destroyAllWindows()
ser.close()
