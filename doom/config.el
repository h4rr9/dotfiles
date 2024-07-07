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
(setq doom-font (font-spec :family "Liga SFMono Nerd Font" :size 22))
(setq doom-variable-pitch-font (font-spec :family "Liga SFMono Nerd Font" :size 22))
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
(setq display-line-numbers-type 'nil)

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


(setq auth-sources '("~/.authinfo"))
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
        lsp-ui-sideline-enable nil
        ;; lsp-headerline-breadcrumb-enable t
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
    ("^\\*Shell Command Output" :slot -1 :size 0.50 :quit 'current :select t)
    ("^\\*Async" :slot -1 :size 0.50 :quit 'current :select t)
    ("^\\*Python" :slot -1 :size 0.50 :quit 'current :select t)
    ("^\\*lsp-help" :slot -1 :select nil)
    )
  )
;; blackhole
(setq fancy-splash-image (concat doom-user-dir "assets/black-hole-small.png"))

(setq epg-pinentry-mode 'loopback)

(setq ispell-alternate-dictionary (concat doom-user-dir "assets/english_dict.txt"))


(defun pinentry-emacs (desc prompt ok error)
  (let ((str (read-passwd (concat (replace-regexp-in-string "%22" "\"" (replace-regexp-in-string "%0A" "\n" desc)) prompt ": "))))
    str))


;; company
(after! company
  (setq company-minimum-prefix-length 2)
  (setq company-show-quick-access t)
  )


;; easy vertical/horizontal split
(defun cust/vsplit-file-open (f)
  (let ((evil-vsplit-window-right t))
    (+evil/window-vsplit-and-follow)
    (find-file f)))

(defun cust/split-file-open (f)
  (let ((evil-split-window-below t))
    (+evil/window-split-and-follow)
    (find-file f)))

(map! :after embark
      :map embark-file-map
      "V" #'cust/vsplit-file-open
      "X" #'cust/split-file-open)


;;; :completion company
;; IMO, modern editors have trained a bad habit into us all: a burning need for
;; completion all the time -- as we type, as we breathe, as we pray to the
;; ancient ones -- but how often do you *really* need that information? I say
;; rarely. So opt for manual completion:
(after! company
  (setq company-idle-delay nil))
;; Implicit /g flag on evil ex substitution, because I use the default behavior
;; less often.
(setq evil-ex-substitute-global t)

;; (add-to-list '+lookup-provider-url-alist '("Zig std" "https://ziglang.org/documentation/master/std/#A;std?%s"))


(after! vterm
  :config
  (setq vterm-timer-delay 0.01)
  )

(after! lsp-zig
  :config
  (setq lsp-zig-enable-autofix t)
  (setq lsp-zig-warn-style t)
  (setq lsp-zig-enable-build-on-save t)
  (setq lsp-zig-build-on-save-step "check")
  )


(add-to-list 'image-types 'svg)
(add-to-list 'image-types 'gif)
;; double buffering fix https://github.com/doomemacs/doomemacs/issues/2217#issuecomment-568037014
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

(after! projectile
  :config
  (defun my/set-org-agenda-files (org-file)
    "Set `org-agenda-files` to only include the given ORG-FILE."
    (setq org-agenda-files (list org-file))
    (message "Updated org-agenda-files: %s" org-agenda-files))


  (defun my/projectile-create-org-file ()
    "Create a dedicated org file for the current Projectile project with dynamic fields."
    (let* ((project-root (projectile-project-root))
           (org-file (concat project-root "project.org"))
           (title (projectile-project-name))
           (author user-full-name)
           (email user-mail-address)
           (date (format-time-string "<%Y-%m-%d %a>"))
           (content (format "#+title: %s\n#+author: %s\n#+email: %s\n#+date: %s\n\n* PROJECT %s\n** TODO <First Task>\n"
                            title author email date title)))
      (unless (file-exists-p org-file)
        (with-temp-file org-file
          (insert content))
        (message "Created project org file: %s" org-file))
      (my/set-org-agenda-files org-file)))


  (defun my/projectile-switch-project-action ()
    "Switch to the project's org file when switching projects."
    (my/projectile-create-org-file)
    (find-file (concat (projectile-project-root) "project.org")))

  (setq projectile-switch-project-action 'my/projectile-switch-project-action)
  )


(after! org
  :config

  (setq org-todo-keywords '
        ((sequence "TODO(t)" "PROG(p!)" "BLOCK(b@/!)" "PROJECT(r)"
                   "|"
                   "DONE(d/!)" "KILL(k@/!)")))
  ;; Ensure that log entries are recorded in the :PROPERTIES: drawer
  (setq org-log-into-drawer t)

  ;; Optionally, specify which logs to include in the drawer
  (setq org-log-state-notes-into-drawer t)
  (setq org-log-done 'time)
  (setq org-log-redeadline 'time)
  (setq org-log-reschedule 'time)

  (setq org-projectile-per-project-filepath "project.org")
  )


(after! org-capture
  :config

  (defun +org--capture-local-root (path)
    (let ((filename (file-name-nondirectory path)))
      (expand-file-name
       filename
       (or (locate-dominating-file (file-truename default-directory)
                                   filename)
           (doom-project-root)
           (user-error "Couldn't detect a project")))))

  (defun +org-capture-project-org-file ()
    "Find the nearest `+org-capture-todo-file' in a parent directory, otherwise,
        opens a blank one at the project root. Throws an error if not in a project."
    (+org--capture-local-root "project.org"))

  (setq org-capture-templates
        '(("t" "Personal todo" entry
           (file+headline +org-capture-todo-file "Inbox")
           "* [ ] %?\n%i\n%a" :prepend t)
          ("n" "Personal notes" entry
           (file+headline +org-capture-notes-file "Inbox")
           "* %u %?\n%i\n%a" :prepend t)
          ("j" "Journal" entry
           (file+olp+datetree +org-capture-journal-file)
           "* %U %?\n%i\n%a" :prepend t)

          ;; NOTE: copied from  https://github.com/doomemacs/doomemacs/blob/21a427c33b57ab66eb7caa2830c0dfe930509318/modules/lang/org/config.el#L376
          ;; modified to save into single project.org file
          ;; instead of separate todo chagelod and notes files.
          ;;
          ;; Will use {project-root}/{todo,notes,changelog}.org, unless a
          ;; {todo,notes,changelog}.org file is found in a parent directory.
          ;; Uses the basename from `+org-capture-todo-file',
          ;; `+org-capture-changelog-file' and `+org-capture-notes-file'.
          ("p" "Templates for projects")
          ("pt" "Project-local todo" entry  ; {project-root}/project.org
           (file+headline +org-capture-project-org-file "Tasks")
           "* TODO %?\n%i\n%a" :prepend t)
          ("pn" "Project-local note" entry  ; {project-root}/project.org
           (file+headline +org-capture-project-org-file "Notes")
           "* %U %?\n%i\n%a" :prepend t)
          ("pc" "Project-local changelog" entry  ; {project-root}/project.org
           (file+headline +org-capture-project-org-file "Unreleased")
           "* %U %?\n%i\n%a" :prepend t)

          ;; Will use {org-directory}/{+org-capture-projects-file} and store
          ;; these under {ProjectName}/{Tasks,Notes,Changelog} headings. They
          ;; support `:parents' to specify what headings to put them under, e.g.
          ;; :parents ("Projects")
          ("o" "Centralized templates for projects")
          ("ot" "Project todo" entry
           (function +org-capture-central-project-todo-file)
           "* TODO %?\n %i\n %a"
           :heading "Tasks"
           :prepend nil)
          ("on" "Project notes" entry
           (function +org-capture-central-project-notes-file)
           "* %U %?\n %i\n %a"
           :heading "Notes"
           :prepend t)
          ("oc" "Project changelog" entry
           (function +org-capture-central-project-changelog-file)
           "* %U %?\n %i\n %a"
           :heading "Changelog"
           :prepend t))
        )

  )
