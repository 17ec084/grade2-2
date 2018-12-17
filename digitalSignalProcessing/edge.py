import cv2

img = cv2.imread("Lenna.jpg")
edge_img = cv2.Canny(img, 70, 150)

cv2.imshow("edge", edge_img)
cv2.waitKey(0)