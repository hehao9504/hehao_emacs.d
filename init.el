;; init.el -- My configuration for Emacs
;; Commentary:
;; Author: He Hao
;; Created on: 04 April 2020
;; Copyright (c) 2020 He Hao <hehao9504@gmail.com>
;;
;; Some Ideas or codes from
;;   1. Suvrat Apte [Github](https://github.com/suvratapte/dot-emacs-dot-d)
;;   2. Emacs ELPA 源使用帮助 @ USTC [Link](https://mirrors.ustc.edu.cn/help/elpa.html)
;;

;; ──────────────────────────────── Set up 'package' ────────────────────────────────
(require 'package)

;; Add melpa to package archives.
(setq package-archives '(("gnu"   . "https://mirrors.ustc.edu.cn/elpa/gnu/")
                         ("melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/")
                         ("melpa-stable" . "https://mirrors.ustc.edu.cn/elpa/melpa-stable/")
                         ("org"   . "https://mirrors.ustc.edu.cn/elpa/org/")))

;; Load and activate emacs packages. Do this first so that the packages are loaded before
;; you start trying to modify them.  This also sets the load path.
(package-initialize)

;; Install 'use-package' if it is not installed.
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

;; ───────────────────────────── Self-defined Functions ─────────────────────────────

;; 全屏函数
(defun my-fullscreen ()
        (interactive)
        (set-frame-parameter nil 'fullscreen
                             (if (frame-parameter nil 'fullscreen) nil 'fullboth)))

(run-with-idle-timer 0.1 nil 'my-fullscreen)

;; ───────────────────────────── GUI better defaults ─────────────────────────────
(setq-default
 ;; Don't use the compiled code if its the older package.
 load-prefer-newer t

 ;; Do not show the startup message.
 inhibit-startup-message t
 inhibit-splash-screen t
 initial-scratch-message nil

 ;; major mode when boot-up: org-mode
 initial-major-mode 'org-mode

 ;; (add-to-list 'default-frame-alist '(fullscreen . maximized))

 ;; Do not put 'customize' config in init.el; give it another file.
 custom-file "~/.emacs.d/custom-file.el"

 ;; Load custom file
 load-file custom-file

 ;; 72 is too less for the fontsize that I use.
 fill-column 90

 ;; Use your name in the frame title. :)
 frame-title-format (format "%s's Emacs" (capitalize user-login-name))

 ;; Do not create lockfiles.
 create-lockfiles nil

 ;; Don't use hard tabs
 indent-tabs-mode nil

 ;; Emacs can automatically create backup files. This tells Emacs to put all backups in
 ;; ~/.emacs.d/backups. More info:
 ;; http://www.gnu.org/software/emacs/manual/html_node/elisp/Backup-Files.html
 backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))

 ;; Do not autosave.
 auto-save-default nil

 ;; Allow commands to be run on minibuffers.
 enable-recursive-minibuffers t)

;; Change all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

;; Make the command key behave as 'meta'
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta))

;; `C-x o' is a 2 step key binding. `M-o' is much easier.
(global-set-key (kbd "M-o") 'other-window)

;; Delete whitespace just when a file is saved.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Enable narrowing commands.
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

;; Display column number in mode line.
(column-number-mode t)

;; Automatically update buffers if file content on the disk has changed.
(global-auto-revert-mode t)


;; 让 cnfonts 随着 Emacs 自动启动
;; (cnfonts-enable)

;;  ─────────────────────────── Disable unnecessary UI elements  ─────────────────────────
(progn
  ;; Do not show menu bar.
  (menu-bar-mode -1)

  ;; Do not show tool bar.
  (when (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))

  ;; Do not show scroll bar.
  (when (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

  ;; Highlight line on point.
  (global-hl-line-mode t))

;; ───────────────────── Additional packages and their configurations ────────────────────
(require 'use-package)

;; Add `:doc' support for use-package so that we can use it like what a doc-strings is for
;; functions.
(eval-and-compile
  (add-to-list 'use-package-keywords :doc t)
  (defun use-package-handler/:doc (name-symbol _keyword _docstring rest state)
    "An identity handler for :doc.
     Currently, the value for this keyword is being ignored.
     This is done just to pass the compilation when :doc is included

     Argument NAME-SYMBOL is the first argument to `use-package' in a declaration.
     Argument KEYWORD here is simply :doc.
     Argument DOCSTRING is the value supplied for :doc keyword.
     Argument REST is the list of rest of the  keywords.
     Argument STATE is maintained by `use-package' as it processes symbols."

    ;; just process the next keywords
    (use-package-process-keywords name-symbol rest state)))

;; ───────────────────────────  GUI Interface for Look and feel ────────────────────────

;; Theme Selection: Spacemacs
(use-package spacemacs-common
  :ensure spacemacs-theme
  :commands spacemacs-theme
;;  :defer t
  :init
    (load-theme 'spacemacs-dark t)          ;; Using the dark theme
    (setq spacemacs-theme-comment-bg nil)   ;; Do not use diff background color for comments
    (setq spacemacs-theme-comment-italic t) ;; Comments should appear in italics
    )

;; ─────────────────────────────── Org-Mode Configuration ──────────────────────────────

;; Personal Information for Emacs
(setq user-full-name "Hao He"
      user-mail-address "hehao9504@gmail.com"
      calendar-latitude 31.02
      calendar-logitude 121.44
      calendar-location-name "Shanghai, China")

;; Org-Mode 自动换行
(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))
(add-hook 'org-mode-hook (lambda () (setq word-wrap t)))

;; 使用 org-superstar 配置不同 headline 的图标，让 headline 变得更漂亮和醒目
(use-package org-superstar
  :ensure t
  :init
    (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
  :config
    (setq org-superstar-headline-bullets-list '("☰" "☷" "☯" "☭"))
    )

;; 配置中英文字体同步放大和缩小
;; PS：采用了中英文混合字体，这个似乎不需要了
(global-set-key [(control x) (meta -)] (lambda () (interactive) (bhj-step-frame-font-size -1)))
(global-set-key [(control x) (meta +)] (lambda () (interactive) (bhj-step-frame-font-size 1)))

;; 设置中英文字体
;; 最开始使用 cnfonts 的中英文混搭的方案，但是存在很多毛病，比如 中英文对齐问题、缩放导致的中英文对齐（中文不放大、英文放大）问题
;; 目前采用的方案是用 中英文混合字体
;; 测试下来，比较好看的字体有几种：
;;  1. 等距更纱黑体 SC: 不错
;;  2. Microsoft Yahei Mono (微软雅黑 Mono): 不错，但是中英文没有对齐，且字体有点偏上
(set-face-attribute
 'default nil
 :font (font-spec :name "-*-等距更纱黑体 SC-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1"
                  :weight 'normal
                  :slant 'normal
                  :size 20.0))

;; org 标题字体设置
;; - 设置 org 标题 1-8 级的字体大小和颜色，颜色摘抄自 monokai 。
;; - 希望 org-mode 标题的字体大小和正文一致，设成1.0， 如果希望标题字体大一点可以设成1.2
(custom-set-faces
  '(org-level-1 ((t (:inherit outline-1 :height 1.6  :foreground "#FD971F"))))
  '(org-level-2 ((t (:inherit outline-2 :height 1.4  :foreground "#A6E22E"))))
  '(org-level-3 ((t (:inherit outline-3 :height 1.2  :foreground "#66D9EF"))))
  '(org-level-4 ((t (:inherit outline-4 :height 1.0  :foreground "#E6DB74"))))
  '(org-level-5 ((t (:inherit outline-5 :height 1.0  :foreground "#A1EFE4"))))
  '(org-level-6 ((t (:inherit outline-6 :height 1.0  :foreground "#A6E22E"))))
  '(org-level-7 ((t (:inherit outline-7 :height 1.0  :foreground "#F92672"))))
  '(org-level-8 ((t (:inherit outline-8 :height 1.0  :foreground "#66D9EF"))))
  ) ;; end custom-set-faces

;; org-mode 表格中英文字体设置
(set-face-attribute 'org-table  nil
     ;; :font "等距更纱黑体 SC 14"
     ;; :fontset (create-fontset-from-fontset-spec (concat "-*-*-*-*-*--*-*-*-*-*-*-fontset-orgtable" ",han:等距更纱黑体 SC 14"))
     :font (font-spec :name "-*-等距更纱黑体 SC-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1"
                  :weight 'normal
                  :slant 'normal
                  :size 16.0)
     )

;; ==== Org 文档特殊格式（粗体/斜体/下划线等）相关 ====

;; 不用空格分离
;;  - 让中文也可以不加空格就使用行内格式
(setcar (nthcdr 0 org-emphasis-regexp-components) " \t('\"{[:nonascii:]")
(setcar (nthcdr 1 org-emphasis-regexp-components) "- \t.,:!?;'\")}\\[[:nonascii:]")
(org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)
(org-element-update-syntax)
;;  - 规定上下标必须加 {}，否则中文使用下划线时它会以为是两个连着的下标
(setq org-use-sub-superscripts "{}")

;; 隐藏特殊格式标记
(setq org-hide-emphasis-markers t)

;; 颜色配置
(setq org-emphasis-alist
      (quote (("*" bold)
              ("/" italic)
              ("_" underline)
              ("=" (:foreground "yellow" :background "black"))
              ("~" org-verbatim verbatim)
              ("+" (:strike-through t))
              )))

;; 为不同的 org 元素设置不同的 theme
(custom-theme-set-faces
 'user
 '(variable-pitch ((t (:family "等距更纱黑体 SC" :height 1.0 :weight normal))))
 '(fixed-pitch ((t ( :family "等距更纱黑体 SC" :slant normal :weight normal :height 1.0 :width normal)))))

(custom-theme-set-faces
 'user
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-code ((t (:inherit (shadow fixed-pitch)))))
 '(org-document-info ((t (:foreground "dark orange"))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
 '(org-link ((t (:foreground "royal blue" :underline t))))
 '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-property-value ((t (:inherit fixed-pitch))) t)
 '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
 '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

;; ──────────────────────────── Useful Packages for Code editing ──────────────────────

;; Company: Complete Anything
(use-package company ;; Company Mode
  :doc "COMPlete ANYthing"
  :ensure t
  :bind (
         :map
         global-map
         ("TAB" . company-complete-common-or-cycle)
         ;; Use hippie expand as secondary auto complete. It is useful as it is
         ;; 'buffer-content' aware (it uses all buffers for that).
         ("M-/" . hippie-expand)
         :map company-active-map
         ("C-n" . company-select-next)      ;; Coompletion Navigation with 'C-n' & 'C-p'
         ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0) ;; Provide instant autocompletion
  (global-company-mode t)
  )               ;; Use the company mode everywhere for coding

;; Recent buffers in a new Emacs session
(use-package recentf
   :config
   (setq recentf-auto-cleanup 'never
         recentf-max-saved-items 1000
         recentf-save-file (concat user-emacs-directory ".recentf"))
   (recentf-mode t)
   :diminish nil)

;; Display possible completions at all places
(use-package ido-completing-read+
   :ensure t
   :config
   ;; This enables ido in all contexts where it could be useful, not just
   ;; for selecting buffer and file names
   (ido-mode t)
   (ido-everywhere t)
   ;; This allows partial matches, e.g. "uzh" will match "Ustad Zakir Hussain"
   (setq ido-enable-flex-matching t)
   (setq ido-use-filename-at-point nil)
   ;; Includes buffer names of recently opened files, even if they're not open now.
   (setq ido-use-virtual-buffers t)
   :diminish nil)

;; Enhance M-x to allow easier execution of commands
(use-package smex
   :ensure t
   ;; Using counsel-M-x for now. Remove this permanently if counsel-M-x works better.
   :disabled t
   :config
   (setq smex-save-file (concat user-emacs-directory ".smex-items"))
   (smex-initialize)
   :bind ("M-x" . smex))

;; Git integration for Emacs
(use-package magit
   :ensure t
   :bind ("C-x g" . magit-status))

;; Better handling of paranthesis when writing Lisps.
(use-package paredit
   :ensure t
   :init
   (add-hook 'clojure-mode-hook #'enable-paredit-mode)
   (add-hook 'cider-repl-mode-hook #'enable-paredit-mode)
   (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
   (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
   (add-hook 'ielm-mode-hook #'enable-paredit-mode)
   (add-hook 'lisp-mode-hook #'enable-paredit-mode)
   (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
   (add-hook 'scheme-mode-hook #'enable-paredit-mode)
   :config
   (show-paren-mode t)
   :bind (("M-[" . paredit-wrap-square)
          ("M-{" . paredit-wrap-curly))
   :diminish nil)

(use-package pdf-tools
  :doc "Better pdf viewing"
  :disabled t
  :ensure t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :bind (:map pdf-view-mode-map
              ("j" . image-next-line)
              ("k" . image-previous-line))
  :delight)

(use-package centaur-tabs
   :demand
   :config
   (setq centaur-tabs-style "bar"
	  centaur-tabs-height 32
	  centaur-tabs-set-icons t
	  centaur-tabs-set-modified-marker t
	  centaur-tabs-show-navigation-buttons t
	  centaur-tabs-set-bar 'under
	  x-underline-at-descent-line t)
   (centaur-tabs-headline-match)
   ;; (setq centaur-tabs-gray-out-icons 'buffer)
   ;; (centaur-tabs-enable-buffer-reordering)
   ;; (setq centaur-tabs-adjust-buffer-order t)
   (centaur-tabs-mode t)
   (setq uniquify-separator "/")
   (setq uniquify-buffer-name-style 'forward))
