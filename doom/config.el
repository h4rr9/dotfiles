;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Hariganesh Srinivasan"
      user-mail-address "hariganeshs1999@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Liga SFMono Nerd Font" :size 12.5))
(setq doom-variable-pitch-font (font-spec :family "Liga SFMono Nerd Font" :size 12.5))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'kanagawa)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


(setq projectile-project-search-path '(("~/work". 1) ("~/sandbox" . 1)))

(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      password-cache-expiry nil                   ; I can trust my computers ... can't I?
      ;; scroll-preserve-screen-position 'always     ; Don't have `point' jump around
      scroll-margin 2                             ; It's nice to maintain a little margin
      display-time-default-load-average nil)      ; I don't think I've ever found this useful

(display-time-mode 1)                             ; Enable time in the mode-line
(setq display-time-24hr-format 't)

(unless (string-match-p "^Power N/A" (battery))   ; On laptops...
  (display-battery-mode 1))                       ; it's nice to know how much power you have

(global-subword-mode 1)                           ; Iterate through CamelCase words


(add-to-list 'default-frame-alist '(height . 35))
(add-to-list 'default-frame-alist '(width . 92))

(setq evil-vsplit-window-right t
      evil-split-window-below t)

(defadvice! prompt-for-buffer (&rest _) :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))


;; evil-snipe
(setq! evil-snipe-scope 'buffer)
;; evil-cursor-insert-mode
(setq! evil-insert-state-cursor 'box)


;; lsp performace fix
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq lsp-idle-delay 0.500)
(setq lsp-use-plists 't)


;; env-vars
(add-to-list 'exec-path "~/.local/bin")
(add-to-list 'exec-path "~/.cargo/bin")


;; scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) - 3) ((control)))
      scroll-conservatively 3
      scroll-margin 3
      maximum-scroll-margin 0.2)
(setq-hook! 'term-mode-hook scroll-margin 0)


;; theme
(setq doom-modeline-height 35
      nav-flash-delay 0.25
      which-key-idle-delay 2.0)

;; whitespace
(setq-default show-trailing-whitespace nil)
(add-hook! (prog-mode text-mode conf-mode)
  (defun doom-enable-show-trailing-whitespace-h ()
    (setq show-trailing-whitespace t)))

;; keybinds
(map!
 :m "]e" #'flycheck-next-error
 :m "[e" #'flycheck-previous-error
 :m "]E" #'next-error
 :m "[E" #'previous-error
 :leader :desc "show diagnostics at point" "c X" #'flycheck-explain-error-at-point
 )

;; lsp-ui
(after! lsp-ui
  :config
  (setq lsp-ui-doc-enable nil
        lsp-headerline-breadcrumb-enable t
        lsp-signature-auto-activate nil
        lsp-signature-render-documentation nil
        )
  )

;; popup rules
(set-popup-rules!
  '(
    ("^\\*cargo" :slot -1 :size 0.50 :quit 'current :select t)
    ("^\\*rustic-compilation" :slot -1 :size 0.50 :quit 'current :select t)
    ("^\\*compilation" :slot -1 :size 0.50 :quit 'current :select t)
    ("^\\*Python" :slot -1 :size 0.50 :quit 'current :select t)
    ("^\\*lsp-help" :slot -1 :select nil)
   )
)
;; blackhole
(setq fancy-splash-image (concat doom-user-dir "assets/black-hole-small.png"))

;; todo keywords
(after! org
  (setq org-startup-with-latex-preview t)
  (setq org-todo-keywords
      '((sequence
         "TODO(t)" ; doing later
         "NEXT(n)" ; doing now or soon
         "|"
         "DONE(d)" ; done
         )
        (sequence
         "WAIT(w)" ; waiting for some external change
         "HOLD(h)" ; waiting for some internal change
         "IDEA(i)" ; maybe someday
         "|"
         "NOTE(o@/!)" ; end state, just keep track of it
         "STOP(s@/!)" ; stopped waiting, decided not to work on it
         ))
        org-todo-keyword-faces
        '(
          ("TODO" :foreground "#C34043" :weight bold :underline t)
          ("NEXT" :foreground "#E82424" :weight bold :underline t)
          ("DONE" :foreground "#2B3328" :weight normal )

          ("WAIT" :foreground "#FFA066" :weight bold :underline t)
          ("HOLD" :foreground "#FF9E3B" :weight bold :underline t)
          ("IDEA" :foreground "#938AA9" :weight bold :underline t)
          ("NOTE" :foreground "#7E9CD8" :weight normal )
          ("STOP" :foreground "#6A9589" :weight normal )

          )
      )
  (setq org-agenda-files '("~/org/notes.org"))
;; capture templates
(setq org-capture-templates
  '(("t" "Tasks" entry
     (file+headline "" "Inbox")
     "* TODO %?\n%u\n%a\n" :clock-in t :clock-resume t)
    ("p" "Papers" entry
     (file+headline "" "Papers")
     "* TODO Read %a%?\n %U")
    ("c" "Phone Call" entry
     (file+headline "" "Inbox")
     "* TODO Call %?\n %U")
("m" "Meeting" entry
 (file+headline "" "Meetings")
 "* %?\n %U")
("j" "Journal Entry" entry
 (file+datetree "journal.org")
 "* %U\n%?")))

)




;; org-latex
(with-eval-after-load 'ox-latex
  (add-to-list 'org-latex-classes
               '("org-plain-latex"
                 "\\documentclass{article}
                [NO-DEFAULT-PACKAGES]
                [PACKAGES]
                [EXTRA]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")
                 )))

(setq org-latex-listings 't)
(setq org-hide-emphasis-markers 't)
(setq org-hide-leading-stars 't)
(setq org-startup-indented 't)
(setq org-latex-caption-above 't)
(font-lock-add-keywords 'org-mode
                        '(("^ +\\([-*]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(setq epg-pinentry-mode 'loopback)


;; deft
(after! deft
  :config
  (setq deft-directory "~/org")
  (setq deft-recursive t)
  (setq deft-use-filter-string-for-filename t)
  (setq deft-default-extension '("org" "txt"))
      (defun cm/deft-parse-title (file contents)
    "Parse the given FILE and CONTENTS and determine the title.
  If `deft-use-filename-as-title' is nil, the title is taken to
  be the first non-empty line of the FILE.  Else the base name of the FILE is
  used as title."
      (let ((begin (string-match "^#\\+[tT][iI][tT][lL][eE]: .*$" contents)))
    (if begin
        (string-trim (substring contents begin (match-end 0)) "#\\+[tT][iI][tT][lL][eE]: *" "[\n\t ]+")
      (deft-base-filename file))))

    (advice-add 'deft-parse-title :override #'cm/deft-parse-title)

    (setq deft-strip-summary-regexp
      (concat "\\("
          "[\n\t]" ;; blank
          "\\|^#\\+[[:alpha:]_]+:.*$" ;; org-mode metadata
          "\\|^:PROPERTIES:\n\\(.+\n\\)+:END:\n"
          "\\)"))
)

;; (setq! citar-bibliography '("~/org/citar.bib"))
;; (setq! org-cite-insert-processor 'citar)
;; (setq! org-cite-follow-processor 'citar)
;; (setq! org-cite-activate-processor 'citar)

;; bib
(use-package! citar
  :config
(setq! citar-bibliography '("~/org/citar.bib")
       citar-library-paths '("~/org/papers")
       citar-notes-paths '("~/org/roam/references")
       citar-library-file-extensions (list "pdf" "jpg")
       citar-file-additional-files-separator "-"
       citar-file-parser-functions '(citar-file--parser-default citar-file--parser-triplet)
       )
(setq! org-cite-export-processors '((latex . biblatex) (html . basic)))
)


;; org-roam

(use-package! org-roam
  :custom
  (org-roam-directory "~/org/roam")
  (org-roam-complete-everywhere t)
)

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam

  :config
   (setq org-roam-ui-sync-theme t
         org-roam-ui-follow t
         org-roam-ui-update-on-save t
         org-roam-ui-open-on-start t)
)


(use-package! elfeed
  :config
(defun concatenate-authors (authors-list)
    "Given AUTHORS-LIST, list of plists; return string of all authors concatenated."
    (if (> (length authors-list) 1)
        (format "%s et al." (plist-get (nth 0 authors-list) :name))
      (plist-get (nth 0 authors-list) :name)))

(defun my-search-print-fn (entry)
    "Print ENTRY to the buffer."
    (let* ((date (elfeed-search-format-date (elfeed-entry-date entry)))
        (title (or (elfeed-meta entry :title)
                    (elfeed-entry-title entry) ""))
        (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
        (entry-authors (concatenate-authors
                        (elfeed-meta entry :authors)))
        (title-width (- (window-width) 10
                        elfeed-search-trailing-width))
        (title-column (elfeed-format-column
                        title 100
                        :left))
        (entry-score (elfeed-format-column (number-to-string (elfeed-score-scoring-get-score-from-entry entry)) 10 :left))
        (authors-column (elfeed-format-column entry-authors 40 :left)))
    (insert (propertize date 'face 'elfeed-search-date-face) " ")

    (insert (propertize title-column
                        'face title-faces 'kbd-help title) " ")
    (insert (propertize authors-column
                        'kbd-help entry-authors) " ")
    (insert entry-score " ")))




  (add-hook! 'elfeed-search-mode-hook 'elfeed-update)
  (setq elfeed-search-date-format '("%y-%m-%d" 10 :left))
  (setq elfeed-search-title-max-width 110)
  (setq elfeed-search-filter "@2-week-ago +unread")
  (setq elfeed-search-print-entry-function #'my-search-print-fn)
  (setq elfeed-search-date-format '("%y-%m-%d" 10 :left))
  (setq elfeed-search-title-max-width 110)
  (defun my/elfeed-entry-to-arxiv ()
    "Fetch an arXiv paper into the local library from the current elfeed entry. "
    (interactive)
    (let* ((link (elfeed-entry-link elfeed-show-entry))
           (match-idx (string-match "arxiv.org/abs/\\([0-9.]*\\)" link))
           (matched-arxiv-number (match-string 1 link)))
      (when matched-arxiv-number
        (message "Going to arXiv: %s" matched-arxiv-number)
        (async-shell-command (format "arxiv-scrape %s" matched-arxiv-number))
       )))
  (map! :leader
        :desc "arXIv paper to library" "n a" #'my/elfeed-entry-to-arxiv
        :desc "Elfeed" "n e" #'elfeed)
)


(use-package! elfeed-score
  :after elfeed
  :config
  (elfeed-score-load-score-file "~/.doom.d/elfeed.score")
  ;; (setq elfeed-score-serde-score-file "~/.doom.d/elfeed.serde.score")
  (elfeed-score-enable)
  (define-key elfeed-search-mode-map "=" elfeed-score-map))


(use-package! citar-org-roam
  :after citar org-roam
  :config (citar-org-roam-mode)
  (setq citar-org-roam-note-title-template "${author} - ${title}")
  (setq citar-org-roam-capture-template-key "n")
)


;; epub
(use-package! nov
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (setq nov-save-place-file (concat doom-cache-dir "nov-places"))
  )

;; citar-org-roam only offers the citar-org-roam-note-title-template variable
;; for customizing the contents of a new note and no way to specify a custom
;; capture template. And the title template uses citar's own format, which means
;; we can't run arbitrary functions in it.
;;
;; Left with no other options, we override the
;; citar-org-roam--create-capture-note function and use our own template in it.
(defun dh/citar-org-roam--create-capture-note (citekey entry)
  "Open or create org-roam node for CITEKEY and ENTRY."
  ;; adapted from https://jethrokuan.github.io/org-roam-guide/#orgc48eb0d
  (let ((title (citar-format--entry
                citar-org-roam-note-title-template entry)))
    (org-roam-capture-
     :templates
     '(("r" "reference" plain "%?" :if-new
        (file+head
         "%(concat
 (when citar-org-roam-subdir (concat citar-org-roam-subdir \"/\")) \"${citekey}.org\")"
         "#+title: ${title}\n\n")
        :immediate-finish t
        :unnarrowed t))
     :info (list :citekey citekey)
     :node (org-roam-node-create :title title)
     :props '(:finalize find-file))
    (org-roam-ref-add (concat "@" citekey))
    (org-roam-property-add "NOTER_DOCUMENT" (concat "../../papers/" citekey ".pdf"))
    ))

;; citar has a function for inserting bibtex entries into a buffer, but none for
;; returning a string. We could insert into a temporary buffer, but that seems
;; silly. Plus, we'd have to deal with trailing newlines that the function
;; inserts. Instead, we do a little copying and implement our own function.
(defun dh/citar-get-bibtex (citekey)
  (let* ((bibtex-files
          (citar--bibliography-files))
         (entry
          (with-temp-buffer
            (bibtex-set-dialect)
            (dolist (bib-file bibtex-files)
              (insert-file-contents bib-file))
            (bibtex-search-entry citekey)
            (let ((beg (bibtex-beginning-of-entry))
                  (end (bibtex-end-of-entry)))
              (buffer-substring-no-properties beg end)))))
    entry))

(advice-add #'citar-org-roam--create-capture-note :override #'dh/citar-org-roam--create-capture-note)


(after! lsp-julia
  :config
  (defun my/julia-repl-send-cell()
    "Send the current julia cell (delimited by ###) to the julia shell"
    (interactive)
    (save-excursion (setq cell-begin (if (re-search-backward "^###" nil t) (point) (point-min))))
    (save-excursion (setq cell-end (if (re-search-forward "^###" nil t) (point) (point-max))))
    (set-mark cell-begin)
    (goto-char cell-end)
    (julia-repl-send-region-or-line)
    (next-line))
  (evil-add-command-properties #'my/julia-repl-send-cell :jump t)
)


(setq ispell-alternate-dictionary (concat doom-user-dir "assets/english_dict.txt"))
