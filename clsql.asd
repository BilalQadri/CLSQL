;;;; -*- Mode: LISP; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;;;; *************************************************************************
;;;; FILE IDENTIFICATION
;;;;
;;;; Name:          clsql.system
;;;; Purpose:       Defsystem-3/4 for CLSQL
;;;; Programmer:    Kevin M. Rosenberg
;;;; Date Started:  Feb 2002
;;;;
;;;; $Id: clsql.asd,v 1.6 2002/09/06 11:08:19 kevin Exp $
;;;;
;;;; This file, part of CLSQL, is Copyright (c) 2002 by Kevin M. Rosenberg
;;;;
;;;; CLSQL users are granted the rights to distribute and use this software
;;;; as governed by the terms of the Lisp Lesser GNU Public License
;;;; (http://opensource.franz.com/preamble.html), also known as the LLGPL.
;;;; *************************************************************************

(declaim (optimize (debug 3) (speed 3) (safety 1) (compilation-speed 0)))

(in-package :asdf)

#-clsql-base
(let ((path (make-pathname :name "clsql-base" :type "system"
				      :defaults *load-truename*)))
  (when (probe-file path)
    (load path)))

;;; System definitions


(defsystem clsql
  :pathname #.(format nil "~A:clsql;"
		      #+common-lisp-controller "cl-library"
		      #-common-lisp-controller "clsql")
  :perform (load-op :after (op clsql)
		    (pushnew :clsql cl:*features*))
  :components ((:file "package")
	       (:file "pool" :depends-on ("package"))
	       (:file "loop-extension")
	       (:file "sql" :depends-on ("pool"))
	       (:file "transactions" :depends-on ("sql"))
	       (:file "functional" :depends-on ("sql"))
	       (:file "usql" :depends-on ("sql")))
  :depends-on (:clsql-base)
  )

(defmethod source-file-type  ((c cl-source-file)
			      (s (eql (find-system 'clsql)))) 
   "cl")

