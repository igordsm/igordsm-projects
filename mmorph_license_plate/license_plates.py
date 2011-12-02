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
        
    
def remove_components_touching_border(img):
    # remove touching border
    border = numpy.zeros((480, 640), numpy.uint8)
    border[0] = border[479] = border[0:480, 0] = border[0:480, 639] = 255

    tmp = cv2.dilate(border, None)
    border_old = border
    border = cv2.bitwise_and(img, tmp)
    while mat_equal(border, border_old) == False:
        tmp = cv2.dilate(border, None)
        border_old = border
        border = cv2.bitwise_and(img, tmp)
    return img - border
    
def double_threshold(img, t_min, t_max):
    r, img_min = cv2.threshold(img, t_min, 255, cv2.THRESH_BINARY)
    r, img_max = cv2.threshold(img, t_max, 255, cv2.THRESH_BINARY)
    mask = img_min - img_max
    return cv2.bitwise_and(img, mask)
    
original = cv2.imread(sys.argv[1], 0)
resized = cv2.resize(original, (640, 480))
#resized = double_threshold(resized, 50, 240)
grad = cv2.morphologyEx(resized, cv2.MORPH_GRADIENT, None)
cv2.imwrite('grad.png', grad)
r, grad_bw = cv2.threshold(grad, 30, 255, cv2.THRESH_BINARY)
cv2.imwrite('grad_bw.png', grad_bw)
d = cv2.morphologyEx(grad_bw, cv2.MORPH_CLOSE, cv2.getStructuringElement(cv2.MORPH_RECT, (50, 1), (25, 0)))
d = cv2.morphologyEx(d, cv2.MORPH_CLOSE, None)
cv2.imwrite('d.png', d)

#elimina maiores (horizontalmente) que a placa
d2 = cv2.morphologyEx(d, cv2.MORPH_OPEN, cv2.getStructuringElement(cv2.MORPH_RECT, (1, 30), (0, 15)) )
d3 = d2
cv2.imwrite('d2.png', d2)

d3 = remove_components_touching_border(d2)

cv2.imwrite('d3.png', d3)
cv2.imwrite('double_t.png', resized)
cv2.imwrite('grad.png', grad)
