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
    original_color =    cv2.imread(sys.argv[1]) 
    original = cv2.imread(sys.argv[1], 0)
    resized = cv2.resize(original, (640, 480))
    return original_color, original, resized
    
def pre_processing(resized):
    grad = cv2.morphologyEx(resized, cv2.MORPH_GRADIENT, None)
    cv2.imwrite('1-pre1.png', grad)
    r, grad_bw = cv2.threshold(grad, 30, 255, cv2.THRESH_BINARY)
    cv2.imwrite('1-pre2.png', grad_bw)
    pre = cv2.morphologyEx(grad_bw, cv2.MORPH_CLOSE, cv2.getStructuringElement(cv2.MORPH_RECT, (50, 1), (25, 0)))
    cv2.imwrite('1-pre3.png', pre)
    pre = cv2.morphologyEx(pre, cv2.MORPH_CLOSE, None)
    cv2.imwrite('1-pre4.png', pre)
    return grad, pre

        
def remove_smaller_than_license_plate(d):
    d2 = cv2.morphologyEx(d, cv2.MORPH_OPEN, cv2.getStructuringElement(cv2.MORPH_RECT, (50, 30), (25, 15)) )
    cv2.imwrite('2-sm1.png', d2)  
    return d2

    
def remove_components_touching_border(img):
    # remove touching border
    border = numpy.zeros((480, 640), numpy.uint8)
    border[0] = border[479] = border[0:480, 0] = border[0:480, 639] = 255
    border = sup_reconstruction(border, img)
    d3 = img - border
    cv2.imwrite('3-border.png', d3)
    return d3


def remove_elements(d3):
    #farois
    
    d4 = cv2.morphologyEx(d3, cv2.MORPH_CLOSE, cv2.getStructuringElement(cv2.MORPH_RECT, (400, 1), (200, 0)) )
    d4 = d4 - d3
    d4 = remove_components_touching_border(d4)

    d3 = d4 + d3
    cv2.imwrite('4-rem1.png', d3)
    
    #maiores verticalmente sao eliminados
    d4 = cv2.morphologyEx(d3, cv2.MORPH_OPEN, cv2.getStructuringElement(cv2.MORPH_RECT, (1, 70), (0, 35)) )
    d4 = d3 - sup_reconstruction(d4, d3)
    cv2.imwrite('4-rem2.png', d4)
    #menores Hori sao eliminados
    d5 = cv2.morphologyEx(d4, cv2.MORPH_OPEN, cv2.getStructuringElement(cv2.MORPH_RECT, (100, 1), (50, 0)) )
    cv2.imwrite('4-rem3.png', d5)
    #maiores Hori sao eliminados
    d6 = cv2.morphologyEx(d4, cv2.MORPH_OPEN, cv2.getStructuringElement(cv2.MORPH_RECT, (170, 1), (85, 0)) )
    d6 = d5 - sup_reconstruction(d6, d5)
    cv2.imwrite('4-rem4.png', d6)
    return d6
    
def watershed(resized, d5):
    r, bg = cv2.threshold(cv2.bitwise_not(cv2.dilate(d5, None, iterations=10)), 30, 125, cv2.THRESH_BINARY)
    fg = d5
    cv2.imwrite('bg.png', bg)
    cv2.imwrite('fg.png', fg)
    marker = cv2.add(fg, bg, dtype=cv2.CV_32SC1)
    marker32 = numpy.zeros((480, 640), numpy.int32)
    marker32[:,:] = marker
    cv2.imwrite('markers.png', marker)

    color = numpy.zeros((480, 640, 3), numpy.uint8)
    color[:,:,0] = resized 
    color[:,:,1] = resized
    color[:,:,2] = resized
    cv2.watershed(color, marker32)

    cv2.imwrite('watersheds.png', marker32)
    return marker32
    
def generate_final_image(color_image, marker):
    mk = numpy.zeros((480, 640, 3), numpy.uint8)
    mk[:,:,0] = marker
    mk[:,:,1] = marker
    mk[:,:,2] = marker
    vis = cv2.addWeighted(color_image, 0.5, mk, 0.5, 0.0, dtype=cv2.CV_8UC3)
    cv2.imwrite('final.png', vis)
    return vis
    
original_color, original, resized = load_image()

bth = cv2.morphologyEx(resized, cv2.MORPH_BLACKHAT, cv2.getStructuringElement(cv2.MORPH_RECT, (7, 7), (3, 3)))
cv2.imwrite('1-pre0.png', bth)
r, d = cv2.threshold(bth, 30, 255, cv2.THRESH_BINARY)
cv2.imwrite('1-pre1.png', d)
d2 = cv2.erode(d, cv2.getStructuringElement(cv2.MORPH_RECT, (1, 7), (0, 3)))
d3 = sup_reconstruction(d2, d)
cv2.imwrite('1-pre2.png', d3)
d4 = cv2.morphologyEx(d3, cv2.MORPH_CLOSE, cv2.getStructuringElement(cv2.MORPH_RECT, (21, 21), (10, 10)))
cv2.imwrite('1-pre3.png', d4)

d5 = cv2.erode(d4, cv2.getStructuringElement(cv2.MORPH_RECT, (151, 1), (75, 0)))

d6 = sup_reconstruction(d5, d4)
d7 = d4 - d6
cv2.imwrite('1-pre4.png', d7)

d8 = cv2.morphologyEx(d7, cv2.MORPH_OPEN, cv2.getStructuringElement(cv2.MORPH_RECT, (91, 9), (45, 4)))
cv2.imwrite('1-pre5.png', d8)


"""d4 = cv2.erode(d, cv2.getStructuringElement(cv2.MORPH_RECT, (51, 1), (25, 0)))
d5 = sup_reconstruction(d4, d3)
cv2.imwrite('1-pre3.png', d5)"""


"""grad, d = pre_processing(resized)
d2 = remove_smaller_than_license_plate(d)
d5 = remove_elements(d2)
marker32 = watershed(resized, d5)
generate_final_image(original_color, marker32)
"""
