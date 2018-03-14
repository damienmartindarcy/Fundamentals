# Blur Image

# Load image
import cv2
import numpy as np
from matplotlib import pyplot as plt


# Load image as grayscale
image = cv2.imread('images/plane_256x256.jpg', cv2.IMREAD_GRAYSCALE)

# Blur image
image_blurry = cv2.blur(image, (5,5))

# Show image
plt.imshow(image_blurry, cmap='gray'), plt.xticks([]), plt.yticks([])
plt.show()