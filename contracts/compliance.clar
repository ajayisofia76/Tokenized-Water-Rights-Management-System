;; Compliance Contract
;; Ensures adherence to regulatory requirements

(define-data-var admin principal tx-sender)

;; Map to store compliance status
(define-map compliance-status
  { holder: principal, year: uint }
  { compliant: bool, last-audit: uint })

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u100))

;; Check if caller is admin
(define-private (is-admin)
  (is-eq tx-sender (var-get admin)))

;; Set compliance status for a rights holder
(define-public (set-compliance-status
                (holder principal)
                (year uint)
                (compliant bool))
  (begin
    (asserts! (is-admin) ERR-NOT-AUTHORIZED)
    (ok (map-set compliance-status
                { holder: holder, year: year }
                { compliant: compliant, last-audit: block-height }))))

;; Get compliance status for a rights holder
(define-read-only (get-compliance-status (holder principal) (year uint))
  (default-to { compliant: false, last-audit: u0 }
              (map-get? compliance-status { holder: holder, year: year })))

;; Check if a rights holder is compliant
(define-read-only (is-compliant (holder principal) (year uint))
  (get compliant (get-compliance-status holder year)))

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin) ERR-NOT-AUTHORIZED)
    (ok (var-set admin new-admin))))
