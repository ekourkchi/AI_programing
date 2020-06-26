
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

if __name__ == '__main__':
  
  
  alpha = 0.25   # training rate
  
  X1 = [0, 0, 1, 1]
  X2 = [0, 1, 0, 1]
  
  T  = [0, 0, 0, 1]
  
  
  # node  1 
  w1 = 0    ## --> connected to X1
  w2 = 0.4    ## --> connected to X2
  theta = 0.3
  

  
  print ""
  print "X1, X2, theta, w1, w2, w3, w4, w5, w6"
  
  for iteration in range(40):
    print "\n ---  iretation" , iteration+1, '------'
    for i in range(4):
      
      y = neuron(X1[i], X2[i], w1, w2, theta)
    

      
      
      if y != T[i]:     # modify is needed 
	w1 += alpha*(T[i] - y) * X1[i]

	
	w2 += alpha*(T[i] - y) * X2[i]

    
	theta = theta -  alpha*(T[i] - y)
	
      
      
      print X1[i], X2[i], theta, w1, w2
    
  
  # Test the network:
  print " Testing the resulting network ....."
  print ""
  print "X1, X2, y, T"
  for i in range(4):
      
      y = neuron(X1[i], X2[i], w1, w2, theta)

      print X1[i], X2[i], y, T[i]
  print ""
  print "w1 = ", w1
  print "w2 = ", w2

  print ""
