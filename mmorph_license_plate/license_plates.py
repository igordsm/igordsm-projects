import cv
import sys


original = cv.LoadImageM(sys.argv[1], cv.CV_LOAD_IMAGE_GRAYSCALE)
resized = cv.CreateMat(640, 480, cv.CV_8UC1)





