;; Rights Holder Verification Contract
;; Validates legitimate water users

(define-data-var admin principal tx-sender)

;; Map to store verified rights holders
(define-map rights-holders principal bool)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ALREADY-REGISTERED (err u101))
(define-constant ERR-NOT-REGISTERED (err u102))

;; Check if caller is admin
(define-private (is-admin)
  (is-eq tx-sender (var-get admin)))

;; Register a new rights holder
(define-public (register-rights-holder (holder principal))
  (begin
    (asserts! (is-admin) ERR-NOT-AUTHORIZED)
    (asserts! (is-none (map-get? rights-holders holder)) ERR-ALREADY-REGISTERED)
    (ok (map-set rights-holders holder true))))

;; Remove a rights holder
(define-public (remove-rights-holder (holder principal))
  (begin
    (asserts! (is-admin) ERR-NOT-AUTHORIZED)
    (asserts! (is-some (map-get? rights-holders holder)) ERR-NOT-REGISTERED)
    (ok (map-delete rights-holders holder))))

;; Check if a principal is a verified rights holder
(define-read-only (is-verified-holder (holder principal))
  (default-to false (map-get? rights-holders holder)))

;; Transfer admin rights
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin) ERR-NOT-AUTHORIZED)
    (ok (var-set admin new-admin))))
