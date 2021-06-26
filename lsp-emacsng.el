;;; lsp-emacsng.el --- emacsng async           -*- lexical-binding: t; -*-

(defun lsp-emacsng-handler (p i)
  (let ((result (lsp-handler p i)))
    (setq my/result result)
    (run-with-idle-timer 0 nil 'lsp--parser-on-message my/result lsp-global-workspace)))

(provide 'lsp-emacsng)
;;; lsp-emacsng.el ends here
