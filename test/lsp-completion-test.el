;;; lsp-completion-test.el --- lsp-completion tests  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Ivan Yonchovski

;; Author: Ivan Yonchovski <yyoncho@gmail.com>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'lsp-completion)
(require 'ert)

(ert-deftest lsp-completion-test-candidate-kind ()
  (should (eq (lsp-completion--candidate-kind
               (propertize " " 'lsp-completion-item
                           (lsp-make-completion-item :kind 3)))
              'function)))

(ert-deftest lsp-completion-test-fuz-score ()
  (let ((query "as")
        (cands '("hashCode() : int"
                 "asSubclass(Class<U> clazz) : Class<? extends U>")))
    (should (equal (sort cands (lambda (l r) (> (lsp-completion--fuz-score query l)
                                                (lsp-completion--fuz-score query r))))
                   '("asSubclass(Class<U> clazz) : Class<? extends U>"
                     "hashCode() : int"))))

  (let ((query "as")
        (cands '("hash-map"
                 "as-definition"
                 "as-def"
                 "aS-selection"
                 "To-as-expected"
                 "amused"
                 "subclass-1"
                 "superand-sort")))
    (should (equal (sort cands (lambda (l r) (> (lsp-completion--fuz-score query l)
                                                (lsp-completion--fuz-score query r))))
                   '("as-definition"    ; Prefix match
                     "as-def"           ; Also prefix match (stable)
                     "hash-map"         ; middle match
                     "amused"           ; partial match with prefix match
                     "To-as-expected"   ; more in middle match
                     "subclass-1"       ; more in middle match
                     "superand-sort"    ; partial match without prefix match
                     "aS-selection"     ; case mismatch
                     )))))

(provide 'lsp-completion-test)
;;; lsp-completion-test.el ends here
