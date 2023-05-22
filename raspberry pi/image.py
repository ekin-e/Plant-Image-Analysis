# Write your code here :-)
from picamera import PiCamera
import time

camera = PiCamera()
time.sleep(2)
camera.resolution = (1024, 768)

file_name = "/home/pi/img/img_" + str(time.asctime(time.localtime(time.time()))) + ".jpg"

camera.capture(file_name)
print("Done")