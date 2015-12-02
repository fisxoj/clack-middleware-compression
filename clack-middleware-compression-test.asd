#|
  This file is a part of clack-middleware-compression project.
  Copyright (c) 2015 Matt Novenstern (fisxoj@gmail.com)
|#

(in-package :cl-user)
(defpackage clack-middleware-compression-test-asd
  (:use :cl :asdf))
(in-package :clack-middleware-compression-test-asd)

(defsystem clack-middleware-compression-test
  :author "Matt Novenstern"
  :license ""
  :depends-on (:clack-middleware-compression
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "clack-middleware-compression"))))
  :description "Test system for clack-middleware-compression"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
