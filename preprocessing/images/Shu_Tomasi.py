# Shu-Tomasi Corner Detector

# Load image
import cv2
import numpy as np
from matplotlib import pyplot as plt
 
# Load images
image_bgr = cv2.imread('images/plane_256x256.jpg')
image_gray = cv2.cvtColor(image_bgr, cv2.COLOR_BGR2GRAY)
 
# Number of corners to detect
corners_to_detect = 10
minimum_quality_score = 0.05
minimum_distance = 25
 
# Detect corners
corners = cv2.goodFeaturesToTrack(image_gray, 
                                  corners_to_detect, 
                                  minimum_quality_score,
                                  minimum_distance)
corners = np.float32(corners)
 
# Draw white circle at each corner
for corner in corners:
    x, y = corner[0]
    cv2.circle(image_bgr, (x,y), 10, (255,255,255), -1)
 
# Convert to grayscale
image_gray = cv2.cvtColor(image_bgr, cv2.COLOR_BGR2GRAY)

# Show image
plt.imshow(image_gray, cmap='gray'), plt.axis("off")
plt.show()