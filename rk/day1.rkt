#lang racket/base

(require racket/file)
(require racket/format)
(require racket/list)

(define (problem-1)
  (let* ([lines (file->lines "../inputs/Day1.txt")]
         [numbers (map string->number lines)])
    (for ([pair (cartesian-product numbers numbers )])
      (let ([a (first pair)]
            [b (second pair)])
        (when (and (< a b) (= 2020 (+ a b)))
          (displayln (~a a " " b " " (* a b))))))))

(define (problem-2)
  (let* ([lines (file->lines "../inputs/Day1.txt")]
         [numbers (map string->number lines)])
    (for ([triple (cartesian-product numbers numbers numbers)])
      (let ([a (first triple)]
            [b (second triple)]
            [c (third triple)])
        (when (and (< a b) (< b c) (= 2020 (+ a b c)))
          (displayln (~a a " " b " " c " " (* a b c))))))))

(begin (problem-1)
       (problem-2))
