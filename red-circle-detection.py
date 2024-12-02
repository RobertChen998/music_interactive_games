'''
ref:https://github.com/ChristophRahn/red-circle-detection
'''
import numpy as np
import cv2

# init camera
cap = cv2.VideoCapture(0)
if not cap.isOpened():
    print("camera is not opened, plz check the connection")
    exit()

# set parameters
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
cap.set(cv2.CAP_PROP_FPS, 30)

while True:
    # capture frame
    ret, captured_frame = cap.read()
    if not ret:
        print("can't receive frame, exiting...")
        break
    
    output_frame = captured_frame.copy()

    # convert to BGR
    captured_frame_bgr = cv2.cvtColor(captured_frame, cv2.COLOR_BGRA2BGR)
    # blur the image to reduce noise
    captured_frame_bgr = cv2.medianBlur(captured_frame_bgr, 3)
    # convert to Lab color space
    captured_frame_lab = cv2.cvtColor(captured_frame_bgr, cv2.COLOR_BGR2Lab)
    # detect red color, and create a mask
    captured_frame_lab_red = cv2.inRange(
        captured_frame_lab, 
        np.array([20, 150, 150]), 
        np.array([190, 255, 255])
    )
    # blur the mask
    captured_frame_lab_red = cv2.GaussianBlur(captured_frame_lab_red, (5, 5), 2, 2)
    # process the mask with morphological operations
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

    # save red points
    red_points = []

    if circles is not None:
        circles = np.round(circles[0, :]).astype("int")
        for (x, y, r) in circles:
            # plot the circle
            cv2.circle(output_frame, (x, y), r, (0, 255, 0), 2)
            cv2.circle(output_frame, (x, y), 2, (0, 0, 255), 3)  # 標記中心點
            cv2.putText(output_frame, f"({x},{y})", (x - 10, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 1)
            # save the red points
            red_points.append((x, y))

    # print red points
    if red_points:
        print("red point axis:", red_points)

    # display the frame
    cv2.imshow('Red Points Detection', output_frame)

    # push 'q' to exit
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# release the camera
cap.release()
cv2.destroyAllWindows()
