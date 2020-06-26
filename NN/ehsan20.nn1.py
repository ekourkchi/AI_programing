
###
# Written by Ehsan Kourkchi (September 2015)
# email: ehsan@ifa.hawaii.edu
# This code, identifies groups of galaxies, given a 
# a cataloge of galaxies. The radial velocity of galaxies would 
# be used to find galaxies with relatively the same radial velocities
# and almost the same position on the sky
###

## Importing Important Python Libraries
import sys
import os
import random
import numpy as np
from math import *
from time import time



#################################################################
def neuron(Xi, Xj, Wi, Wj, threshold):
  
  a = Wi*Xi + Wj*Xj  # activation
  
  if a < threshold:
    return 0
  else:
    return 1
#################################################################

if __name__ == '__main__':
  
  
  alpha = 0.1  # training rate
  
  X1 = [0, 0, 1, 1]
  X2 = [0, 1, 0, 1]
  
  T  = [0, 1, 1, 1]
  
  
  # node  1 
  w1 = 0      ## --> connected to X1
  w2 = 0.4    ## --> connected to X2
  theta1 = 0.3
  
  # node  2
  w3 = 1    ## --> connected to X1
  w4 = 1    ## --> connected to X2
  theta2 = 1.5
  
  # node  3 
  w5 = 1    ## --> connected to X1
  w6 = 1    ## --> connected to X2
  theta3 = 1.5
  
  
  print ""
  
  
  for iteration in range(3):
    print "\n ---  iretation" , iteration+1, '------'
    print "X1, X2 \t|  theta1 theta2 theta3 |  w1, w2, w3, w4, w5, w6"
    for i in range(4):
      
      y1 = neuron(X1[i], X2[i], w1, w2, theta1)
      y2 = neuron(X1[i], X2[i], w3, w4, theta2)
      y3 = neuron(X1[i], X2[i], w5, w6, theta3)
      
      y = max(y1, y2, y3)
      
      
      if y != T[i]:     # modify is needed 
	w1 += alpha*(T[i] - y) * X1[i]
	w3 += alpha*(T[i] - y) * X1[i]
	w5 += alpha*(T[i] - y) * X1[i]
	
	w2 += alpha*(T[i] - y) * X2[i]
	w4 += alpha*(T[i] - y) * X2[i]
	w6 += alpha*(T[i] - y) * X2[i]
    
	theta1 -= alpha*(T[i] - y)
	theta2 -= alpha*(T[i] - y)
	theta3 -= alpha*(T[i] - y)
      
      
      print X1[i], X2[i], '\t|', theta1, theta2, theta3, ' | ' , w1, w2, w3, w4, w5, w6
    
  
  # Test the network:
  print "\n\n Testing the resulting network ....."
  print ""
  print "X1, X2 \t| y \t|  T"
  for i in range(4):
      
      y1 = neuron(X1[i], X2[i], w1, w2, theta1)
      y2 = neuron(X1[i], X2[i], w3, w4, theta2)
      y3 = neuron(X1[i], X2[i], w5, w6, theta3)
      
      y = max(y1, y2, y3)
      print X1[i], X2[i], '\t|', y, '\t|', T[i]
  print ""
  print "w1 = ", w1
  print "w2 = ", w2
  print "w3 = ", w3
  print "w4 = ", w4
  print "w5 = ", w5
  print "w6 = ", w6
  print ""
