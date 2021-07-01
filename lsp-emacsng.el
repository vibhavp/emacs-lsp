;;; lsp-emacsng.el --- emacsng async           -*- lexical-binding: t; -*-

(defun lsp-emacsng-handler (p i)
  (let ((result (lsp-handler p i)))
    (setq my/result result)
    (run-with-idle-timer 0 nil 'lsp--parser-on-message my/result lsp-global-workspace)))

(defun lsp-emacsng-send-no-wait (message)
  (let ((id (plist-get message :id))
        (msg (plist-get message :method))
        (params (plist-get message :params)))
    (if id
        (when (stringp (plist-get message :method))
          (lsp-async-send-request my/pipe msg params (number-to-string id)))
      (lsp-async-send-notification my/pipe msg params))))

(defun lsp-emacsng-stdio-connection (command test-command)
  (list :connect (lambda (filter sentinel name environment-fn)
                   (let ((final-command (lsp-resolve-final-function command)))

                     (setq my/pipe (make-lsp-connection (seq-first final-command)
                                                        (seq-rest final-command)
                                                        #'lsp-emacsng-handler))

                     (lsp-json-config my/pipe
                                      :object-type 'hash-table
                                      :false-object :json-false
                                      :ser-false-object nil
                                      :ser-null-object nil)

                     (let ((proc (make-process :name "xxxx"
                                               :command '("ls")
                                               :noquery t)))
                       (cons proc proc))))
        :test? (or
                test-command
                (lambda () (-> command lsp-resolve-final-function lsp-server-present?)))))

(provide 'lsp-emacsng)
;;; lsp-emacsng.el ends here
