;; Institution Verification Contract
;; Validates financial entities in the system

(define-data-var admin principal tx-sender)

;; Map to store verified institutions
(define-map verified-institutions principal bool)

;; Function to verify an institution
(define-public (verify-institution (institution principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u100))
    (ok (map-set verified-institutions institution true))
  )
)

;; Function to check if an institution is verified
(define-read-only (is-verified (institution principal))
  (default-to false (map-get? verified-institutions institution))
)

;; Function to revoke verification
(define-public (revoke-verification (institution principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u100))
    (ok (map-set verified-institutions institution false))
  )
)
