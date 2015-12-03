(in-package :cl-user)
(defpackage clack-middleware-compression
  (:use :cl :annot :alexandria))
(in-package :clack-middleware-compression)

(enable-annot-syntax)

@export
(defparameter *clack-middleware-compression*
  (lambda (app &key (gzip t))
    (lambda (env)
      (let ((response (funcall app env)))
	(if-let ((compression (calculate-compression env :gzip gzip)))
	  (compress-response response compression)
	  response)))))

(defun calculate-compression (env &key gzip)
  "Chooses a compression scheme based on the Accept-Encoding header and middle capabilities."
  (when-let ((accept-encoding (gethash "accept-encoding" (getf env :headers) nil)))
    (cond
      ((and gzip (search "gzip" accept-encoding)) :gzip)
      (t nil))))

(defun get-compressor (compression)
  (cond
    ((eq compression :gzip) 'salza2:gzip-compressor)
    (t (error "No compressor for ~a" compression))))

(defun vectorfy-response (response)
  "Convert the response into a octet vector for salza"
  (let ((payload (if (listp response) (car response) response)))
    (etypecase payload
      (string (babel:string-to-octets payload))
      ((vector (unsigned-byte 8)) payload)
      (pathname (babel:string-to-octets (uiop:read-file-string payload))))))

(defun compress-response (response compression)
  "Takes a clack response list and returns the same response compressed with an appropriate compression method based on configuration and the request headers."
  (let* ((compressor (get-compressor compression))
	 (compressed-response-data (salza2:compress-data
				    (vectorfy-response (third (print response))) compressor)))
    ;; Mark response as encoded
    (setf (getf (second response) :content-encoding) (string-downcase compression)
	  (getf (second response) :content-length) (length compressed-response-data)
	  (third response) compressed-response-data))
  response)
