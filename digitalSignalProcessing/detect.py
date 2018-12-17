import cv2

face_cascade = cv2.CascadeClassifier("/opt/Wolfram/WolframEngine/11.3/SystemFiles/Data/Haarcascades/frontalface.xml")

img = cv2.imread("Lenna.jpg")
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

faces = face_cascade.detectMultiScale(gray, 1.3, 5)

for (x,y,w,h) in faces:
    cv2.rectangle(img,(x,y),(x+w,y+h),(0,0,255),2)

cv2.imshow("detected",img)
cv2.waitKey(0)