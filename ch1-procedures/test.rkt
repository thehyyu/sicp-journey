#lang racket

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x)))

(define (improve guess x)
  (/ (+ guess (/ x guess)) 2.0))

(define (good-enough? guess x)
  (< (abs (- (* guess guess) x)) 0.001))

(define (my-sqrt x)
  (sqrt-iter 1.0 x))

(my-sqrt 2)
(my-sqrt 9)
