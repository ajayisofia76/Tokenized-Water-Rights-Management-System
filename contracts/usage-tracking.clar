;; Usage Tracking Contract
;; Monitors actual consumption

(define-data-var admin principal tx-sender)

;; Map to store water usage (in cubic meters)
(define-map water-usage { holder: principal, year: uint } uint)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INVALID-USAGE (err u104))

;; Check if caller is admin or the rights holder
(define-private (is-authorized (holder principal))
  (or (is-eq tx-sender (var-get admin)) (is-eq tx-sender holder)))

;; Record water usage for a rights holder
(define-public (record-usage (holder principal) (year uint) (amount uint))
  (begin
    (asserts! (is-authorized holder) ERR-NOT-AUTHORIZED)
    (asserts! (>= amount u0) ERR-INVALID-USAGE)
    (ok (map-set water-usage { holder: holder, year: year }
                (+ (get-usage holder year) amount)))))

;; Get usage for a rights holder in a specific year
(define-read-only (get-usage (holder principal) (year uint))
  (default-to u0 (map-get? water-usage { holder: holder, year: year })))

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-AUTHORIZED)
    (ok (var-set admin new-admin))))
