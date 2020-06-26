#!/usr/bin/python
__author__ = "Ehsan Kourkchi"
__copyright__ = "Copyright 2016"
__version__ = "1.0"
__maintainer__ = "Ehsan Kourkchi"
__email__ = "ehsan@ifa.hawaii.edu"
__status__ = "Production"


## Importing Important Python Libraries
import sys
import os
import random
import numpy as np
from math import *
import time
import matplotlib.pyplot as plt
from turtle import *


#################################################################
# my Turtle .... For animation :)
#################################################################
def plot_turtle(n, error):
  # Get the user's input.
  
  # width, height, startx, stary
  setup(600, 400, 100 , 100)
  
  # Set up the drawing coordinates.
  screen = Screen()
  
  screen.setworldcoordinates(0, -0.1, n, 1.1) # llx,lly,urx,ury
  turtle = Turtle()        
  turtle.speed('fastest')
  turtle.hideturtle()      
  
  turtle.pen(pencolor="grey", pensize=1)


  # horizontal
  for i in np.arange(-0.1,1.1,0.1):
    turtle.up()
    turtle.goto(0, i)
    turtle.down()
    turtle.forward(n)
  turtle.pen(pencolor="black", pensize=2)
  turtle.up()
  turtle.goto(0, 0)
  turtle.down()
  turtle.forward(n)
  
  # vertical
  turtle.pen(pencolor="grey", pensize=1)
  turtle.left(90)
  for i in np.arange(0, n, 10):
    turtle.up()
    turtle.goto(i, -0.1)
    turtle.down()
    turtle.forward(1.2)
  turtle.pen(pencolor="black", pensize=2)
  turtle.up()
  turtle.goto(0, 0)
  turtle.down()
  turtle.forward(1.1)  
  
  turtle.pen(pencolor="red", pensize=3)
  turtle.up()
  turtle.goto(0, error[0])
  turtle.down()
  i = 1 
  while i<n:
    turtle.goto(i, error[i])
    time.sleep(0.2)
    if i%10 ==0: print 'step: ', i
    i+=1
    
#################################################################
# Here I defined the neuron characteristics
#################################################################
# W[0] is the bias 
# W has one element more than X

# it's the same as Theta in lecture notes
def neuron(W, X):
  
  if len(W) != len(X)+1:
    print "W should have one more element than X ..."
    return 0
  
  a = -1.*W[0]  # activation
  for i in range(len(X)):
    a += X[i]*W[i+1]
    
  if a < 0:
    return 0
  else:
    return 1

#################################################################
#################################################################
#################################################################
#################################################################
#      THE  BODY OF THE CODE
#################################################################
#  Here we define our problem
#################################################################
n = 60     # numberof iterations
C = 0.01    # training rate

X = []     # input list
L = []     # label list

# X1, L1 (1 xor 1 -> 0)
X.append([1,1])
L.append(0)


# X2, L2 (1 xor 0 -> 1)
X.append([1,0])
L.append(1)

# X3, L3 (0 xor 1 -> 1)
X.append([0,1])
L.append(1)

# X4, L4 (0 xor 0 -> 0)
X.append([0,0])
L.append(0)

# initializing weights
W  = [0.3]  # weight list - initialized with bias
# has the same dimension as each X_list memmebt, X
W.append(0.1)
W.append(0.3)
#################################################################


N = len(X)

for j in range(N):
  X[j] = np.asarray(X[j])
L = np.asarray(L)
W = np.asarray(W)
W0 = np.copy(W)   # taking a copy of initial values

error = np.zeros(n)

for iteration in range(n):
  
  for j in range(N):
    
     Yj = neuron(W, X[j])
     W[1:] += C*(L[j]-Yj)*X[j]       # ---> weight modification
     W[0]   = W[0]-C*(L[j]-Yj)       # ---> bias modification
     
     error[iteration] += (L[j]-Yj)**2
  

error = np.sqrt(error/N)
#################################################################
# Printing Outputs 

print 
print '---------------------------------'
print 'initial weights: ', W0[1:]
print 'initial bias: ', W0[0]
print 'learning factor: ', C
print '# of iterations: ', n
print '---------------------------------'
print 'X --> Label  --- Network Solution'
print '---------------------------------'
for j in range(N):
  Y = neuron(W, X[j])
  print X[j], ' --> ', L[j], ' .... ', Y 

print
print 'bias: ', W[0]
print 'weights: ', W[1:]
print '---------------------------------'
print

#################################################################


# Plotting
plt.plot(range(n), error)
plt.xlabel(r'$Step$', fontsize=12)
plt.ylabel(r'$Error$', fontsize=12)
plt.xlim(0,n)
plt.ylim(-0.1,1.1)
plt.show()


# Turtle Animation
plot_turtle(n, error)

