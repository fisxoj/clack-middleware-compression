#|
  This file is a part of clack-middleware-compression project.
  Copyright (c) 2015 Matt Novenstern (fisxoj@gmail.com)
|#

#|
  Author: Matt Novenstern (fisxoj@gmail.com)
|#

(in-package :cl-user)
(defpackage clack-middleware-compression-asd
  (:use :cl :asdf))
(in-package :clack-middleware-compression-asd)

(defsystem clack-middleware-compression
  :version "0.1"
  :author "Matt Novenstern"
  :license "LLGPLv3"
  :depends-on (#:cl-annot
	       #:alexandria
	       #:salza2
	       #:babel)
  :components ((:module "src"
                :components
                ((:file "clack-middleware-compression"))))
  :description "A compression middleware for clack web apps"
  :in-order-to ((test-op (test-op clack-middleware-compression-test))))
