;; Transaction Monitoring Contract
;; Analyzes payment patterns

(define-data-var admin principal tx-sender)

;; Structure to store transaction data
(define-map transactions
  { tx-id: (string-ascii 64) }
  {
    sender: principal,
    receiver: principal,
    amount: uint,
    timestamp: uint
  }
)

;; Function to record a transaction
(define-public (record-transaction
    (tx-id (string-ascii 64))
    (receiver principal)
    (amount uint))
  (begin
    (ok (map-set transactions
      { tx-id: tx-id }
      {
        sender: tx-sender,
        receiver: receiver,
        amount: amount,
        timestamp: block-height
      }
    ))
  )
)

;; Function to get transaction details
(define-read-only (get-transaction (tx-id (string-ascii 64)))
  (map-get? transactions { tx-id: tx-id })
)
