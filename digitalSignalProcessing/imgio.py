import cv2

img = cv2.imread("Lenna.jpg", 1)

cv2.imshow("souce", img)
cv2.waitKey(0)