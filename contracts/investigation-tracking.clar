;; Investigation Tracking Contract
;; Records review and resolution of fraud cases

(define-data-var admin principal tx-sender)

;; Structure to store investigations
(define-map investigations
  { case-id: uint }
  {
    alert-id: uint,
    investigator: principal,
    status: (string-ascii 20),
    notes: (string-ascii 200),
    timestamp: uint
  }
)

(define-data-var case-counter uint u0)

;; Function to create an investigation
(define-public (create-investigation
    (alert-id uint)
    (status (string-ascii 20))
    (notes (string-ascii 200)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u100))
    (let ((new-id (+ (var-get case-counter) u1)))
      (var-set case-counter new-id)
      (ok (map-set investigations
        { case-id: new-id }
        {
          alert-id: alert-id,
          investigator: tx-sender,
          status: status,
          notes: notes,
          timestamp: block-height
        }
      ))
    )
  )
)

;; Function to update investigation status
(define-public (update-investigation
    (case-id uint)
    (status (string-ascii 20))
    (notes (string-ascii 200)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u100))
    (match (map-get? investigations { case-id: case-id })
      investigation (ok (map-set investigations
                        { case-id: case-id }
                        (merge investigation {
                          status: status,
                          notes: notes,
                          timestamp: block-height
                        })))
      (err u404)
    )
  )
)

;; Function to get investigation details
(define-read-only (get-investigation (case-id uint))
  (map-get? investigations { case-id: case-id })
)
