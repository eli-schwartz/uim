;;; anthy-custom.scm: Customization variables for anthy.scm
;;;
;;; Copyright (c) 2003-2005 uim Project http://uim.freedesktop.org/
;;;
;;; All rights reserved.
;;;
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:
;;; 1. Redistributions of source code must retain the above copyright
;;;    notice, this list of conditions and the following disclaimer.
;;; 2. Redistributions in binary form must reproduce the above copyright
;;;    notice, this list of conditions and the following disclaimer in the
;;;    documentation and/or other materials provided with the distribution.
;;; 3. Neither the name of authors nor the names of its contributors
;;;    may be used to endorse or promote products derived from this software
;;;    without specific prior written permission.
;;;
;;; THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
;;; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
;;; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
;;; OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;;; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;;; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
;;; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
;;; SUCH DAMAGE.
;;;;

(require "i18n.scm")


(define anthy-im-name-label (N_ "Anthy"))
(define anthy-im-short-desc (N_ "A multi-segment kana-kanji conversion engine"))

(define-custom-group 'anthy
                     (ugettext anthy-im-name-label)
                     (ugettext anthy-im-short-desc))


(define-custom 'anthy-commit-transposed-preedit-immediately? #f
  '(anthy)
  '(boolean)
  (_ "Immediately commit after preedit transposition (character set conversion)")
  (_ "long description will be here."))

;;
;; segment separator
;;

(define-custom 'anthy-show-segment-separator? #f
  '(anthy segment-sep)
  '(boolean)
  (_ "Show segment separator")
  (_ "long description will be here."))

(define-custom 'anthy-segment-separator "|"
  '(anthy segment-sep)
  '(string ".*")
  (_ "Segment separator")
  (_ "long description will be here."))

(custom-add-hook 'anthy-segment-separator
		 'custom-activity-hooks
		 (lambda ()
		   anthy-show-segment-separator?))

;;
;; candidate window
;;

(define-custom 'anthy-use-candidate-window? #t
  '(anthy candwin)
  '(boolean)
  (_ "Use candidate window")
  (_ "long description will be here."))

(define-custom 'anthy-candidate-op-count 1
  '(anthy candwin)
  '(integer 0 99)
  (_ "Conversion key press count to show candidate window")
  (_ "long description will be here."))

(define-custom 'anthy-nr-candidate-max 10
  '(anthy candwin)
  '(integer 1 20)
  (_ "Number of candidates in candidate window at a time")
  (_ "long description will be here."))

(define-custom 'anthy-select-candidate-by-numeral-key? #f
  '(anthy candwin)
  '(boolean)
  (_ "Select candidate by numeral keys")
  (_ "long description will be here."))

;; activity dependency
(custom-add-hook 'anthy-candidate-op-count
		 'custom-activity-hooks
		 (lambda ()
		   anthy-use-candidate-window?))

(custom-add-hook 'anthy-nr-candidate-max
		 'custom-activity-hooks
		 (lambda ()
		   anthy-use-candidate-window?))

(custom-add-hook 'anthy-select-candidate-by-numeral-key?
		 'custom-activity-hooks
		 (lambda ()
		   anthy-use-candidate-window?))

;;
;; toolbar
;;

;; Can't be unified with action definitions in anthy.scm until uim
;; 0.4.6.
(define anthy-input-mode-indication-alist
  (list
   (list 'action_anthy_direct
	 'figure_ja_direct
	 "a"
	 (N_ "Direct input")
	 (N_ "Direct input mode"))
   (list 'action_anthy_hiragana
	 'figure_ja_hiragana
	 "��"
	 (N_ "Hiragana")
	 (N_ "Hiragana input mode"))
   (list 'action_anthy_katakana
	 'figure_ja_katakana
	 "��"
	 (N_ "Katakana")
	 (N_ "Katakana input mode"))
   (list 'action_anthy_hankana
	 'figure_ja_hankana
	 "��"
	 (N_ "Halfwidth Katakana")
	 (N_ "Halfwidth Katakana input mode"))
   (list 'action_anthy_zenkaku
	 'figure_ja_zenkaku
	 "��"
	 (N_ "Fullwidth Alphanumeric")
	 (N_ "Fullwidth Alphanumeric input mode"))))

(define anthy-kana-input-method-indication-alist
  (list
   (list 'action_anthy_roma
	 'figure_ja_roma
	 "��"
	 (N_ "Romaji")
	 (N_ "Romaji input mode"))
   (list 'action_anthy_kana
	 'figure_ja_kana
	 "��"
	 (N_ "Kana")
	 (N_ "Kana input mode"))
   (list 'action_anthy_azik
	 'figure_ja_azik
	 "��"
	 (N_ "AZIK")
	 (N_ "AZIK extended romaji input mode"))
   (list 'action_anthy_nicola
	 'figure_ja_nicola
	 "��"
	 (N_ "NICOLA")
	 (N_ "NICOLA input mode"))))

;;; Buttons

(define-custom 'anthy-widgets '(widget_anthy_input_mode
				widget_anthy_kana_input_method)
  '(anthy toolbar)
  (list 'ordered-list
	(list 'widget_anthy_input_mode
	      (_ "Input mode")
	      (_ "Input mode"))
	(list 'widget_anthy_kana_input_method
	      (_ "Kana input method")
	      (_ "Kana input method")))
  (_ "Enabled toolbar buttons")
  (_ "long description will be here."))

;; dynamic reconfiguration
;; anthy-configure-widgets is not defined at this point. So wrapping
;; into lambda.
(custom-add-hook 'anthy-widgets
		 'custom-set-hooks
		 (lambda ()
		   (anthy-configure-widgets)))


;;; Input mode

(define-custom 'default-widget_anthy_input_mode 'action_anthy_direct
  '(anthy toolbar)
  (cons 'choice
	(map indication-alist-entry-extract-choice
	     anthy-input-mode-indication-alist))
  (_ "Default input mode")
  (_ "long description will be here."))

(define-custom 'anthy-input-mode-actions
               (map car anthy-input-mode-indication-alist)
  '(anthy toolbar)
  (cons 'ordered-list
	(map indication-alist-entry-extract-choice
	     anthy-input-mode-indication-alist))
  (_ "Input mode menu items")
  (_ "long description will be here."))

;; value dependency
(if custom-full-featured?
    (custom-add-hook 'anthy-input-mode-actions
		     'custom-set-hooks
		     (lambda ()
		       (custom-choice-range-reflect-olist-val
			'default-widget_anthy_input_mode
			'anthy-input-mode-actions
			anthy-input-mode-indication-alist))))

;; activity dependency
(custom-add-hook 'default-widget_anthy_input_mode
		 'custom-activity-hooks
		 (lambda ()
		   (memq 'widget_anthy_input_mode anthy-widgets)))

(custom-add-hook 'anthy-input-mode-actions
		 'custom-activity-hooks
		 (lambda ()
		   (memq 'widget_anthy_input_mode anthy-widgets)))

;; dynamic reconfiguration
(custom-add-hook 'default-widget_anthy_input_mode
		 'custom-set-hooks
		 (lambda ()
		   (anthy-configure-widgets)))

(custom-add-hook 'anthy-input-mode-actions
		 'custom-set-hooks
		 (lambda ()
		   (anthy-configure-widgets)))

;;; Kana input method

(define-custom 'default-widget_anthy_kana_input_method 'action_anthy_roma
  '(anthy toolbar)
  (cons 'choice
	(map indication-alist-entry-extract-choice
	     anthy-kana-input-method-indication-alist))
  (_ "Default kana input method")
  (_ "long description will be here."))

(define-custom 'anthy-kana-input-method-actions
               (map car anthy-kana-input-method-indication-alist)
  '(anthy toolbar)
  (cons 'ordered-list
	(map indication-alist-entry-extract-choice
	     anthy-kana-input-method-indication-alist))
  (_ "Kana input method menu items")
  (_ "long description will be here."))

;; value dependency
(if custom-full-featured?
    (custom-add-hook 'anthy-kana-input-method-actions
		     'custom-set-hooks
		     (lambda ()
		       (custom-choice-range-reflect-olist-val
			'default-widget_anthy_kana_input_method
			'anthy-kana-input-method-actions
			anthy-kana-input-method-indication-alist))))

;; activity dependency
(custom-add-hook 'default-widget_anthy_kana_input_method
		 'custom-activity-hooks
		 (lambda ()
		   (memq 'widget_anthy_kana_input_method anthy-widgets)))

(custom-add-hook 'anthy-kana-input-method-actions
		 'custom-activity-hooks
		 (lambda ()
		   (memq 'widget_anthy_kana_input_method anthy-widgets)))

;; dynamic reconfiguration
(custom-add-hook 'default-widget_anthy_kana_input_method
		 'custom-set-hooks
		 (lambda ()
		   (anthy-configure-widgets)))

(custom-add-hook 'anthy-kana-input-method-actions
		 'custom-set-hooks
		 (lambda ()
		   (anthy-configure-widgets)))
