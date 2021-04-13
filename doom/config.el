;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;; by aru

(setq user-mail-address "aru_hackz.official@zohomail.eu"
      user-full-name "Alberto Robles Gomez")

;; Startup

(setq fancy-splash-image "~/.config/doom/icons/z.png")
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-footer)

;; Fonts

(setq doom-font                (font-spec :family "Iosevka Term Curly Medium" :size 14)
      doom-variable-pitch-font (font-spec :family "Iosevka Term Curly Medium" :size 14)
      doom-big-font            (font-spec :family "Iosevka Term Curly Medium" :size 20))

(custom-set-faces! '(treemacs-directory-face :foreground "#689d6a"))

;; Doom theme

(use-package! doom-themes
  :config
  (setq doom-themes-enable-bold
        doom-themes-enable-italic
        doom-gruvbox-dark-variant "hard")
  (load-theme 'doom-gruvbox t)
  (setq doom-themes-treemacs-theme "doom-colors")
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

;; Org config

(setq org-directory "~/Documents/ORG/"
      org-agenda-files (list "~/Documents/ORG/inbox.org"
                             "~/Documents/ORG/agenda.org"
                             "~/Documents/ORG/notes.org"
                             "~/Documents/ORG/projects.org")
      org-agenda-fontify-priorities t
      org-priority-highest 1
      org-priority-lowest 5
      org-priority-default 5
      org-todo-keywords '((sequencep "TODO(t)" "NEXT(n)" "|" "DONE(d)" "CANCELED(x)"))
      org-log-done 'time)

(after! org-fancy-priorities
  (setq org-fancy-priorities-list '((?1 . "➀")
                                    (?2 . "➁")
                                    (?3 . "➂")
                                    (?4 . "➃")
                                    (?5 . "➄"))))

(add-hook! 'org-after-todo-state-change-hook #'log-todo-next-creation-date)

;; Org publishing config

(setq org-html-htmlize-output-type 'css
      org-html-head-include-default-style nil
      org-publish-project-alist
      '(("Dotfiles-docs"
        :headline-levels 3
        :recursive t
        :base-extension "org"
        :base-directory "~/Dotfiles/docs.org/"
        :publishing-directory "~/Dotfiles/docs/"
        :publishing-function org-html-publish-to-html)))

;; Org-capture config

(after! org-capture
  (setq org-capture-templates
        '(("i" "Inbox" entry (file "~/Documents/ORG/inbox.org")
           "* TODO %?\n/Entered on/ %U")

          ("m" "Meeting" entry (file+headline "~/Documents/ORG/agenda.org" "Future")
           "* %? :meeting:\n<%<%Y-%m-%d %a %H:00>>")

          ("n" "Note" entry (file "~/Documents/ORG/notes.org")
           "* NOTE (%a)\n/Entered on/ %U\n\n%?")

          ("@" "Inbox [mu4e]" entry (file "~/Documents/ORG/inbox.org")
           "* TODO Reply to \"%a\" %?\n/Entered on/ %U"))))
;; Org-agenda condif


(after! org-agenda
  (setq
      org-agenda-hide-tags-regexp "."
      org-agenda-prefix-format '((agenda . " %i %-12:c%?-12t% s")
                                 (todo   . " ")
                                 (tags   . " %i %-12:c")
                                 (search . " %i %-12:c"))
      org-refile-targets '(("~/Documents/ORG/projects.org"
                            :regexp . "\\(?:\\(?:Note\\|Task\\)s\\)"))
      org-priority-faces '((?1 . (:foreground "#cc241d" :weight extrabold))
                           (?2 . (:foreground "#d65d0e" :weight bold))
                           (?3 . (:foreground "#d79921" :weight semibold))
                           (?4 . (:foreground "#98971a"))
                           (?5 . (:foreground "#689d6a")))
      org-todo-keywords '((sequencep "TODO(t)" "NEXT(n)" "|" "DONE(d)" "CANCELED(c)"))
      org-agenda-custom-commands
      '(("g" "Get Things Done (GTD)"
         ((todo "NEXT"
                ((org-agenda-skip-function
                  '(org-agenda-skip-entry-if 'deadline))
                 (org-agenda-prefix-format " % i%-16 c% s[%e]: ")
                 (org-agenda-overriding-header "\nTasks\n")))
          (tags-todo "inbox"
                     ((org-agenda-prefix-format " % i%-16 c% s[%e]: ")
                      (org-agenda-overriding-header "\nInbox\n")))
          (tags-todo "projects"
                     ((org-agenda-prefix-format " % i%-16 c% s[%e]: ")
                      (org-agenda-skip-function
                       '(org-agenda-skip-entry-if 'nottodo '("TODO")))
                      (org-agenda-overriding-header "\nProjects\n")))
          (tags "CLOSED>=\"<today>\""
                ((org-agenda-prefix-format " % i%-16 c% s[%e]: ")
                 (org-agenda-overriding-header "\nCompleted today\n")))))
        ("d" "Deadlines"
          (agenda nil
                  ((org-agenda-entry-types '(:deadline))
                   (org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'nottode '("NEXT")))
                   (org-agenda-format-date "")
                   (org-deadline-warning-days 7)
                   (org-agenda-overriding-header "\nDeadlines\n")))))))

;; Functions

(defun log-todo-next-creation-date (&rest _)
  "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
  (when (and (string= (org-get-todo-state) "NEXT")
             (not (org-entry-get nil "ACTIVATED")))
    (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d %H:%M]"))))

;; Before this do that

(advice-add 'org-refile :before
            (lambda (&rest _)
              (org-save-all-org-buffers)))

(advice-add 'org-agenda-quit :before
            (lambda (&rest _)
              (org-save-all-org-buffers)))

;; Keybindings

(map! :leader
      :prefix ("X" . "Org Capture / Agenda")
       "" nil
       :desc "View agenda"  "a" #'org-agenda
       :desc "Capture menu" "c" #'org-capture

       (:prefix ("T" . "prefix timestamp")
         :desc "deadline"  "d" #'org-deadline
         :desc "inactive"  "i" #'org-time-stamp-inactive
         :desc "plain"     "p" #'org-time-stamp
         :desc "scheduled" "s" #'org-schedule)

       (:prefix ("X" . "prefix org")
         :desc "Set effort" "f" #'org-set-effort
         :desc "Refile"     "r" #'org-refile
         :desc "Set tags"   "t" #'org-set-tags-command)

       (:prefix ("A" . "prefix agenda")
         :desc "Set effort" "f" #'org-agenda-set-effort
         :desc "Org refile" "r" #'org-agenda-refile
         :desc "Set tags"   "t" #'org-agenda-set-tags)

       (:prefix ("C" . "prefix capture")
         :desc "Org refile" "r" #'org-capture-refile))

;; Random

(setq display-line-numbers-type nil)

(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; Lsp

(setq lsp-enable-file-watchers nil
      haskell-interactive-popup-errors nil)

;; Indentation

(setq css-indent-offset 2)

(doom-themes-neotree-config)
(doom-themes-org-config)

;; Pdf

(use-package! pdf-view
  :hook (pdf-tools-enabled . pdf-view-midnight-minor-mode)
  :hook (pdf-tools-enabled . hide-mode-line-mode)
  :config
  (setq pdf-view-midnight-colors '("#ebdbb2" . "#1d2021")))

;; Email

(setq +mu4e-mu4e-mail-path "~/Documents/MAIL/")

(set-email-account! "Main Mail"
  '((mail-user-agent                     . mu4e-user-agent)
    (smtpmail-smtp-server                . "smtp.zoho.eu")
    (smtpmail-smtp-service               . 465)
    (smtpmail-smtp-user                  . "aru_hackz.official@zohomail.eu")
    (smtpmail-stream-type                . ssl)
    (message-send-mail-function          . smtpmail-send-it)
    (mu4e-sent-folder                    . "/Sent")
    (mu4e-drafts-folder                  . "/Drafts")
    (mu4e-trash-folder                   . "/Trash")
    (mu4e-refile-folder                  . "/Archive")
    (mu4e-attachment-dir                 . "~/Documents/MAIL/Attachments")
    (mu4e-compose-signature-auto-include . nil)
    (mu4e-compose-signature              . "\naru")
    (mu4e-view-show-images               . t)
    (mu4e-use-fancy-chars                . t)
    (mu4e-get-mail-command               . "mbsync --all")
    (mu4e-update-interval                . 300))
  t)

(mu4e-alert-set-default-style 'libnotify)
(add-hook! 'after-init-hook #'mu4e-alert-enable-notifications)
(add-hook! 'after-init-hook #'mu4e-alert-enable-mode-line-display)
