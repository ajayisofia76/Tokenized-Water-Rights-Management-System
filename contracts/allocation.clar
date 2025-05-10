;; Allocation Contract
;; Records permitted withdrawal amounts

(define-data-var admin principal tx-sender)

;; Map to store water allocations (in cubic meters)
(define-map water-allocations principal uint)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ZERO-ALLOCATION (err u103))

;; Check if caller is admin
(define-private (is-admin)
  (is-eq tx-sender (var-get admin)))

;; Set water allocation for a rights holder
(define-public (set-allocation (holder principal) (amount uint))
  (begin
    (asserts! (is-admin) ERR-NOT-AUTHORIZED)
    (asserts! (> amount u0) ERR-ZERO-ALLOCATION)
    (ok (map-set water-allocations holder amount))))

;; Get allocation for a rights holder
(define-read-only (get-allocation (holder principal))
  (default-to u0 (map-get? water-allocations holder)))

;; Update allocation for a rights holder
(define-public (update-allocation (holder principal) (amount uint))
  (begin
    (asserts! (is-admin) ERR-NOT-AUTHORIZED)
    (asserts! (> amount u0) ERR-ZERO-ALLOCATION)
    (ok (map-set water-allocations holder amount))))

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin) ERR-NOT-AUTHORIZED)
    (ok (var-set admin new-admin))))
