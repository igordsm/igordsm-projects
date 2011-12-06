import cv2
import sys
import numpy
    
def mat_equal(img1,img2):
    h, w = img1.shape
    for j in range(w):
        for i in range(h):
            if img1[i, j] != img2[i, j]:
                return False
    return True
    
def sup_reconstruction(marker, img):
    tmp = cv2.dilate(marker, None)
    old = marker
    marker = cv2.bitwise_and(img, tmp)
    while mat_equal(marker, old) == False:
        tmp = cv2.dilate(marker, None)
        old = marker
        marker = cv2.bitwise_and(img, tmp)
    return marker
    
def load_image():
    original_color = cv2.imread(sys.argv[1]) 
    original = cv2.imread(sys.argv[1], 0)
    resized = cv2.resize(original, (640, 480))
    return original_color, original, resized
           
def watershed(img, fg_marker):
    fg_marker = cv2.dilate(fg_marker, None, iterations=5)
    r, bg_marker = cv2.threshold(cv2.bitwise_not(cv2.dilate(fg_marker, None, iterations=10)), 30, 125, cv2.THRESH_BINARY)
    marker = cv2.add(fg_marker, bg_marker, dtype=cv2.CV_32SC1)
    cv2.imwrite('step7-markers.png', marker)

    color = numpy.zeros((480, 640, 3), numpy.uint8)
    color[:,:,0] = img
    color[:,:,1] = img
    color[:,:,2] = img
    cv2.watershed(color, marker)

    cv2.imwrite('step7-watersheds.png', marker)
    return marker
    
def generate_final_image(color_image, marker):
    mk = numpy.zeros((480, 640, 3), numpy.uint8)
    mk[:,:,0] = marker
    mk[:,:,1] = marker
    mk[:,:,2] = marker
    vis = cv2.addWeighted(color_image, 0.3, mk, 0.7, 0.0, dtype=cv2.CV_8UC3)
    cv2.imwrite('step8-final.png', vis)
    return vis
    
original_color, original, resized = load_image()

bth = cv2.morphologyEx(resized, cv2.MORPH_BLACKHAT, cv2.getStructuringElement(cv2.MORPH_RECT, (7, 7), (3, 3)))
cv2.imwrite('step0.png', bth)

r, d = cv2.threshold(bth, 30, 255, cv2.THRESH_BINARY)
cv2.imwrite('step1.png', d)

d2 = cv2.erode(d, cv2.getStructuringElement(cv2.MORPH_RECT, (1, 7), (0, 3)))
d3 = sup_reconstruction(d2, d)
cv2.imwrite('step2.png', d3)

d4 = cv2.morphologyEx(d3, cv2.MORPH_CLOSE, cv2.getStructuringElement(cv2.MORPH_RECT, (31, 1), (15, 0)))
cv2.imwrite('step3.png', d4)

d5 = cv2.erode(d4, cv2.getStructuringElement(cv2.MORPH_RECT, (151, 1), (75, 0)))
d6 = sup_reconstruction(d5, d4)
d7 = d4 - d6
cv2.imwrite('step4.png', d7)

d8 = cv2.morphologyEx(d7, cv2.MORPH_OPEN, cv2.getStructuringElement(cv2.MORPH_RECT, (91, 9), (45, 4)))
d9 = sup_reconstruction(d8, d7)
cv2.imwrite('step5.png', d9)

d10 = cv2.morphologyEx(d9, cv2.MORPH_OPEN, cv2.getStructuringElement(cv2.MORPH_RECT, (1, 51), (0, 25)))
d11 = d9 - sup_reconstruction(d10, d9)
cv2.imwrite('step6.png', d11)

marker32 = watershed(resized, d11)
generate_final_image(original_color, marker32)
