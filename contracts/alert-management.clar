;; Alert Management Contract
;; Handles notification of potential fraud

(define-data-var admin principal tx-sender)

;; Structure to store alerts
(define-map alerts
  { alert-id: uint }
  {
    account: principal,
    risk-score: uint,
    description: (string-ascii 100),
    resolved: bool
  }
)

(define-data-var alert-counter uint u0)

;; Function to create an alert
(define-public (create-alert
    (account principal)
    (risk-score uint)
    (description (string-ascii 100)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u100))
    (let ((new-id (+ (var-get alert-counter) u1)))
      (var-set alert-counter new-id)
      (ok (map-set alerts
        { alert-id: new-id }
        {
          account: account,
          risk-score: risk-score,
          description: description,
          resolved: false
        }
      ))
    )
  )
)

;; Function to resolve an alert
(define-public (resolve-alert (alert-id uint))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u100))
    (match (map-get? alerts { alert-id: alert-id })
      alert (ok (map-set alerts
                { alert-id: alert-id }
                (merge alert { resolved: true })))
      (err u404)
    )
  )
)

;; Function to get alert details
(define-read-only (get-alert (alert-id uint))
  (map-get? alerts { alert-id: alert-id })
)
