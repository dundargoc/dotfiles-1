; Name: Tempus Day
; Description: Light theme with warm colors (WCAG AA compliant)
; Author: Protesilaos Stavrou (https://protesilaos.com)
; URL: https://gitlab.com/protesilaos/tempus-themes
; Modified by: Gregory Anders

(when vim.g.colors_name
  (exec "hi clear"))

(set vim.o.termguicolors true)
(set vim.g.colors_name :light)
(set vim.o.background :light)

(macro make-colors [...]
  (assert-compile (= 0 (math.fmod (select :# ...) 2))
                  "expected even number of group/option pairs")
  (let [colors {:black     {:gui "#4a484d" :cterm 0}
                :red       {:gui "#a50000" :cterm 1}
                :green     {:gui "#005d26" :cterm 2}
                :yellow    {:gui "#714700" :cterm 3}
                :blue      {:gui "#1d3ccf" :cterm 4}
                :magenta   {:gui "#88267a" :cterm 5}
                :cyan      {:gui "#185570" :cterm 6}
                :white     {:gui "#efefef" :cterm 7}
                :brblack   {:gui "#5e4b4f" :cterm 8}
                :brred     {:gui "#992030" :cterm 9}
                :brgreen   {:gui "#4a5500" :cterm 10}
                :bryellow  {:gui "#8a3600" :cterm 11}
                :brblue    {:gui "#2d45b0" :cterm 12}
                :brmagenta {:gui "#700dc9" :cterm 13}
                :brcyan    {:gui "#005289" :cterm 14}
                :brwhite   {:gui "#ffffff" :cterm 15}}
        highlights []]
    (for [i 1 (select :# ...) 2]
      (let [(group opts) (select i ...)
            group (tostring group)
            s (if opts.link
                  (: "hi link %s %s" :format group opts.link)
                  (let [fg (. colors opts.fg)
                        bg (. colors opts.bg)]
                    (: "hi %s guifg=%s guibg=%s ctermfg=%s ctermbg=%s gui=%s cterm=%s" :format
                       group
                       (or (?. fg :gui) :NONE)
                       (or (?. bg :gui) :NONE)
                       (or (?. fg :cterm) :NONE)
                       (or (?. bg :cterm) :NONE)
                       (or opts.attr :NONE)
                       (or opts.attr :NONE))))]
        (table.insert highlights s)))
    `(vim.cmd ,(table.concat highlights "\n"))))

(make-colors
  Normal {:bg "brwhite" :fg "black"}
  Visual {:bg "black" :fg "brwhite"}
  Search {:attr "underline,bold" :bg "white" :fg "black"}
  IncSearch {:attr "underline,bold" :bg "brblack" :fg "brwhite"}

  StatusLine {:bg "black" :fg "brwhite"}
  StatusLineNC {:bg "white" :fg "brblack"}
  StatusLineTerm {:bg "green" :fg "brwhite"}
  StatusLineTermNC {:bg "white" :fg "green"}

  VertSplit {}
  TabLine {:bg "white" :fg "brblack"}
  TabLineSel {:bg "cyan" :fg "brwhite"}
  TabLineFill {}

  Comment {:fg "brblack"}
  Todo {:attr "bold" :bg "white" :fg "bryellow"}

  Warning {:bg "yellow" :fg "brwhite"}
  WarningMsg {:bg "yellow" :fg "brwhite"}
  Error {:guisp "red" :attr "undercurl"}
  ErrorMsg {:bg "red" :fg "brwhite"}

  MatchParen {:attr "bold" :bg "white" :fg "brblack"}
  MatchWord {:link :MatchParen}

  QuickFixLine {:bg "black" :fg "brwhite"}

  ToolbarLine {:bg "brblack" :fg "brwhite"}
  ToolbarButton {:attr "bold" :bg "brblack" :fg "brwhite"}

  WildMenu {:bg "brwhite" :fg "black"}

  Terminal {:bg "brwhite" :fg "black"}

  Constant {:fg "blue"}
  Number {:fg "blue"}
  Float {:fg "blue"}
  String {:fg "brblue"}

  Function {:fg "magenta"}
  Identifier {:fg "brmagenta"}
  Label {:fg "magenta"}
  Tag {:fg "magenta"}
  Keyword {:attr "bold" :fg "brmagenta" :attr "bold"}

  Character {:attr "bold" :fg "brcyan"}

  Type {:attr "none,bold" :fg "cyan"}
  Boolean {:fg "cyan"}
  StorageClass {:fg "cyan"}
  Structure {:fg "cyan"}
  Typedef {:attr "bold" :fg "brcyan"}

  Conditional {:attr "bold" :fg "green"}
  Statement {:fg "brgreen"}
  Repeat {:attr "bold" :fg "brgreen"}
  Operator {:attr "bold" :fg "black"}
  Exception {:attr "bold" :fg "red"}

  Preproc {:fg "brred"}
  PreCondit {:attr "bold" :fg "brred"}
  Macro {:attr "bold" :fg "brred"}
  Include {:fg "brred"}
  Define {:fg "brred"}

  Title {:attr "bold" :bg "brwhite" :fg "cyan"}

  Delimiter {}
  SpecialComment {:attr "bold" :fg "magenta"}

  Debug {:fg "brmagenta"}

  LineNr {:bg "white" :fg "brblack"}
  Cursor {:bg "black" :fg "brwhite"}
  CursorLine {:bg "white"}
  CursorColumn {:bg "white"}
  CursorLineNr {:attr "bold" :bg "brblack" :fg "brwhite"}
  ColorColumn {:bg "white" :fg "black"}
  SignColumn {:bg "white" :fg "brblack"}

  Folded {:bg "white" :fg "brblack"}
  FoldColumn {:bg "white" :fg "brblack"}

  Special {:attr "bold" :fg "bryellow"}
  SpecialKey {:bg "white" :fg "brblack"}
  SpecialChar {:attr "bold" :fg "bryellow"}
  NonText {:fg "brblack"}
  EndOfBuffer {:attr "bold" :fg "brblack"}

  Directory {:fg "green"}
  Question {:attr "bold" :fg "bryellow"}
  MoreMsg {:fg "brgreen"}
  ModeMsg {:attr "bold" :fg "green"}

  VimOption {:fg "magenta"}
  VimGroup {:fg "magenta"}

  Underlined {:attr "underline" :fg "black"}
  Ignore {:bg "white" :fg "brblack"}
  Conceal {:bg "brblack" :fg "white"}

  SpellBad {:bg "red" :fg "brwhite"}
  SpellCap {:bg "yellow" :fg "brwhite"}
  SpellRare {:bg "brmagenta" :fg "brwhite"}
  SpellLocal {:bg "brcyan" :fg "brwhite"}

  Pmenu {:bg "white" :fg "black"}
  PmenuSel {:attr "none,bold" :bg "brblack" :fg "brwhite"}
  PmenuSbar {:bg "white"}
  PmenuThumb {:bg "brblack"}

  DiffAdd {:attr "bold" :bg "green" :fg "brwhite"}
  DiffDelete {:bg "red" :fg "brwhite"}
  DiffChange {:attr "bold" :bg "white" :fg "brblack"}
  DiffText {:attr "bold" :bg "white" :fg "brred"}

  diffAdded {:fg "green"}
  diffRemoved {:fg "red"}
  diffNewFile {:fg "blue"}
  diffFile {:fg "yellow"}

  MarkdownRule {:attr "bold" :bg "white" :fg "brgreen"}

  MarkdownHeading {:attr "bold" :fg "black"}
  MarkdownH1 {:link :MarkdownHeading}
  MarkdownH2 {:link :MarkdownHeading}
  MarkdownH3 {:link :MarkdownHeading}
  MarkdownH4 {:link :MarkdownHeading}
  MarkdownH5 {:link :MarkdownHeading}
  MarkdownH6 {:link :MarkdownHeading}
  MarkdownHeadingDelimiter {:link :MarkdownHeading}
  MarkdownHeadingRule {:link :MarkdownHeading}

  MarkdownBold {:attr "bold" :fg "brred"}
  MarkdownBoldDelimiter {:link :MarkdownBold}

  MarkdownItalic {:attr "italic" :fg "yellow"}
  MarkdownItalicDelimiter {:link :MarkdownItalic}

  MarkdownUrl {:attr "underline" :fg "blue"}
  MarkdownLinkText {:fg "brblue"}
  MarkdownLinkDelimiter {:attr "bold" :fg "black"}
  MarkdownLinkTextDelimiter {:link :MarkdownLinkDelimiter}

  MarkdownCode {:fg "magenta"}
  MarkdownCodeDelimiter {:link :MarkdownCode}

  MarkdownCodeBlock {:fg "black"}

  MarkdownListMarker {:fg "green"}
  MarkdownOrderedListMarker {:link :MarkdownListMarker}

  DiagnosticError {:fg "red"}
  DiagnosticWarn {:fg "yellow"}
  DiagnosticInfo {:fg "blue"}
  DiagnosticHint {:fg "brblack"}
  DiagnosticSignError {:fg "red" :bg "white"}
  DiagnosticSignWarn {:fg "yellow" :bg "white"}
  DiagnosticSignInfo {:fg "blue" :bg "white"}
  DiagnosticSignHint {:fg "brblack" :bg "white"}
  DiagnosticUnderlineError {:guisp "red" :attr "undercurl"}
  DiagnosticUnderlineWarn {:guisp "yellow" :attr "undercurl"}
  DiagnosticUnderlineInfo {:guisp "blue" :attr "undercurl"}
  DiagnosticUnderlineHint {:guisp "brblack" :attr "undercurl"}

  ; Syntax-file specific highlighting
  diffAdded {:fg "green"}
  diffRemoved {:fg "red"}
  diffLine {:fg "cyan"}
  diffFile {:attr "bold"}
  diffIndexLine {:attr "bold"}
  diffSubname {:fg "white"}

  gitcommitHeader {:fg "white"}
  gitcommitSummary {:attr "bold"}
  gitcommitSelectedType {:fg "green"}
  gitcommitSelectedFile {:fg "green"}
  gitcommitDiscardedType {:fg "red"}
  gitcommitDiscardedFile {:fg "red"}
  gitcommitUntrackedFile {:fg "red"}
  gitcommitBranch {:fg "yellow"}

  gitrebaseHash {:fg "yellow"}
  gitrebaseSummary {:fg "white"}
  gitrebasePick {:fg "green"}
  gitrebaseReword {:fg "blue"}
  gitrebaseEdit {:fg "red"}
  gitrebaseSquash {:fg "cyan"}
  gitrebaseFixup {:fg "cyan"}
  gitrebaseExec {:fg "cyan"}
  gitrebaseReset {:fg "cyan"}

  manSubHeading {:fg "red" :attr "bold"}
  manOptionDesc {:fg "red" :attr "bold"}
  manReference {:fg "yellow"}
  manUnderline {:fg "green" :attr "bold"}

  vimOption {}
  vimVar {}
  vimEnvvar {}

  ; Plugin highlighting
  GitSignsAdd {:fg "green" :bg "brgreen"}
  GitSignsDelete {:fg "red" :bg "brgreen"}
  GitSignsChange {:fg "brblack" :bg "brgreen"}

  packerHash {:fg "yellow"}

  TSNone {:fg "white"}
  TSSymbol {:fg "yellow"}
  TSDefinition {:link "MatchWord"}
  TSDefinitionUsage {:link "MatchWord"}

  LspReferenceText {:link "MatchWord"}
  LspReferenceRead {:link "MatchWord"}
  LspReferenceWrite {:link "MatchWord"}

  DapBreakpoint {:fg "cyan" :bg "brgreen"}
  DapBreakpointCondition {:fg "cyan" :bg "brgreen"}
  DapLogPoint {:fg "cyan" :bg "brgreen"}
  DapStopped {:fg "brwhite" :bg "brgreen"}
  DapBreakpointRejected {:fg "red" :bg "brgreen"}

  Sneak {:link "IncSearch"}

  TelescopeSelection {:bg "lightest_gray" :attr "bold"}
  TelescopeMatching {:fg "orange"})
