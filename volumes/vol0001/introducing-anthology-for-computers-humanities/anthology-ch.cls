%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HEADER METADATA INFORMATION
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{anthology-ch}[Anthology of Computers and the Humanities]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WORK OFF OF THE BASE ARTICLE CLASS
\LoadClass[11pt]{article}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD ALL REQUIRED PACKAGES HERE
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{amssymb}
\RequirePackage{booktabs}
\RequirePackage{caption}
\RequirePackage{etoolbox}
\RequirePackage{fancyhdr}
\RequirePackage[
  a4paper,
  top=3cm,
  bottom=3cm,
  left=3cm,
  right=3cm,
  headsep=1.5cm,
  headheight=14pt,
  footskip=1.5cm
]{geometry}
\RequirePackage{graphicx}
\RequirePackage{kvoptions}
%\RequirePackage{times}
%\RequirePackage{ebgaramond}
\RequirePackage{iftex}
\ifXeTeX
  % XeLaTeX: Use fontspec for Tinos fonts
  \RequirePackage{fontspec}
  \setmainfont{Tinos}[
    Extension = .ttf,
    UprightFont = *-Regular,
    BoldFont = *-Bold,
    ItalicFont = *-Italic,
    BoldItalicFont = *-BoldItalic
  ]
\else
  % pdfLaTeX: Use tinos package
  \RequirePackage{tinos}
  \RequirePackage[T1]{fontenc}
\fi
%\RequirePackage{librebaskerville}
\RequirePackage{xcolor}
\RequirePackage{xparse}
\RequirePackage[hidelinks]{hyperref}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CREATE A DRAFT OPTION THAT WE SET WHEN THIS IS THE FINAL VERSION
\newif\if@final
\@finalfalse  % Default is not draft mode
\DeclareOption{final}{\@finaltrue}
\ProcessOptions\relax

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CUSTOM COLORS FOR THE STYLE
\definecolor{customlink}{HTML}{efb840}
\definecolor{newgray}{rgb}{0.7,0.7,0.7}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMMANDS TO GRAB CUSTOM METADATA PRODUCED IN THE TEX FILE
\newcommand{\@keywords}{}
\newcommand{\keywords}[1]{\renewcommand{\@keywords}{#1}}
\newcommand{\@pubyear}{}
\newcommand{\pubyear}[1]{\renewcommand{\@pubyear}{#1}}
\newcommand{\@pubvolume}{}
\newcommand{\pubvolume}[1]{\renewcommand{\@pubvolume}{#1}}
\newcommand{\@pagestart}{}
\newcommand{\pagestart}[1]{\renewcommand{\@pagestart}{#1}}
\newcommand{\@pageend}{}
\newcommand{\pageend}[1]{\renewcommand{\@pageend}{#1}}
\newcommand{\@conferencename}{}
\newcommand{\conferencename}[1]{\renewcommand{\@conferencename}{#1}}
\newcommand{\@conferenceeditors}{}
\newcommand{\conferenceeditors}[1]{\renewcommand{\@conferenceeditors}{#1}}
\newcommand{\@doi}{}
\newcommand{\doi}[1]{\renewcommand{\@doi}{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STORING THE AUTHOR DATA
\newcounter{authorcount}
\setcounter{authorcount}{0}
\def\@authornames{}
\def\@authornamesend{}
\def\@authornamesfull{}
\def\@correspondingauthor{}
\def\@correspondingemail{}

% Storage for author names and affiliations
\newcommand{\@storeauthorname}[2]{\expandafter\def\csname author@name@#1\endcsname{#2}}
\newcommand{\@storeauthoraffil}[2]{\expandafter\def\csname author@affil@#1\endcsname{#2}}

\define@key{author}{orcid}{\def\@currentorcid{#1}}
\define@key{author}{email}{\def\@currentemail{#1}}
\define@key{author}{corresponding}[true]{\def\@currentcorresponding{#1}}
\setkeys{author}{orcid={}, email={}, corresponding=false}

\RenewDocumentCommand{\author}{O{} m O{}}{%
  \stepcounter{authorcount}
  \setkeys{author}{#3}

  % Store the current ORCID ID, email, name, and affiliation for this specific author
  \expandafter\edef\csname author@orcid@\arabic{authorcount}\endcsname{\@currentorcid}
  \expandafter\edef\csname author@email@\arabic{authorcount}\endcsname{\@currentemail}
  \@storeauthorname{\arabic{authorcount}}{#2}
  \@storeauthoraffil{\arabic{authorcount}}{#1}

  % Check if this is the corresponding author
  \ifx\@currentcorresponding\@empty\else
    \def\@temp{true}%
    \ifx\@currentcorresponding\@temp
      \ifx\@correspondingauthor\@empty
        \edef\@correspondingauthor{#2}
        \edef\@correspondingemail{\@currentemail}
      \fi
    \fi
  \fi

  \ifnum\value{authorcount}=1
    \def\@authornames{#2}
    \ifx\@currentorcid\@empty
      \def\@authornamesfull{\mbox{#2}\textsuperscript{#1}}
    \else
      \def\@authornamesfull{\mbox{#2}\textsuperscript{#1}~\href{https://orcid.org/\@currentorcid}{\includegraphics[width=8pt]{orcid.png}}}
    \fi
    \def\@authornamesend{\mbox{#2}}
  \else
    \edef\@authornamesend{\@authornames{}, and \mbox{#2}}
    \appto\@authornames{, \mbox{#2}}
    \ifx\@currentorcid\@empty
      \appto\@authornamesfull{, \mbox{#2}\textsuperscript{#1}}
    \else
      \appto\@authornamesfull{, \mbox{#2}\textsuperscript{#1}~\href{https://orcid.org/\@currentorcid}{\includegraphics[width=8pt]{orcid.png}}}
    \fi
  \fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STORING THE AFFILIATION DATA
\newcounter{affilcount}
\setcounter{affilcount}{0}

\newcommand{\affiliation}[2]{%
  \stepcounter{affilcount}

  \ifnum\value{affilcount}=1
    \def\@affillist{\textsuperscript{#1}~#2}
  \else
    \appto\@affillist{\\\textsuperscript{#1}~#2}
  \fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET THE HEADER AND FOOTER; THESE ARE DIFFERENT ON THE FIRST PAGE
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyheadoffset{1.5cm}

\fancypagestyle{main}{
  \fancyhf{}
  \fancyfoot[C]{\thepage}
}

\fancypagestyle{firstpage}{
  \fancyhf{} 
  \if@final
    \fancyhead[L]{
      \textbf{\small\textcolor{newgray}{Anthology of Computers and the Humanities, Vol. \@pubvolume}}
    }
  \else
    \fancyhead[L]{
      \textbf{\small\textcolor{newgray}{Anthology of Computers and the Humanities: Under Review}}
    }
  \fi
  \fancyfoot[C]{\thepage}
}

\AtBeginDocument{%
  \thispagestyle{firstpage}
  \suppressfloats[t] 
  \suppressfloats[b]
}

\pagestyle{main}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFINE THE FOOTNOTE ON THE FIRST PAGE THAT CONTAINS THE CITATION AND
% THE COPYRIGHT NOTICE ALONG WITH A LINK TO THE CC BY PAGE
\renewcommand\@makefntext[1]{%
\setlength\parindent{1em}%
\noindent
\mbox{\textsuperscript{\@thefnmark}~}{#1}}

\newcommand{\firstpagefootnote}[1]{\gdef\@firstpagefootnote{#1}}

\if@final
  \newcommand{\@firstpagefootnote}{\footnotesize\@authornamesend. ``\@title.''\if\relax\detokenize\expandafter{\@conferencename}\relax\else\ In:~\textit{\@conferencename}\if\relax\detokenize\expandafter{\@conferenceeditors}\relax\else, ed. by \@conferenceeditors\fi.\fi\ Vol. \@pubvolume. Anthology of Computers and the Humanities. \@pubyear, \@pagestart--\@pageend. \href{https://doi.org/\@doi}{https://doi.org/\@doi}.

  \vspace{0.5em}

  \ifx\@correspondingauthor\@empty\else
  \noindent
  Corresponding author: \@correspondingauthor\ (\href{mailto:\@correspondingemail}{\@correspondingemail})

  \vspace{0.5em}
  \fi

  \noindent
  \textcolor{newgray}{© 2025 by the authors. Licensed under \href{https://creativecommons.org/licenses/by/4.0}{Creative Commons Attribution 4.0 International (CC BY 4.0).}}}
\else
  \newcommand{\@firstpagefootnote}{Paper under review.

  \vspace{0.5em}

  \noindent
  \textcolor{newgray}{© 2025 by the authors. Licensed under \href{https://creativecommons.org/licenses/by/4.0}{Creative Commons Attribution 4.0 International (CC BY 4.0).}}}
\fi


\AtBeginDocument{%
  \AtBeginDocument{%
    \begingroup
    \setcounter{page}{\@pagestart}
    \renewcommand{\thefootnote}{} 
    \renewcommand{\footnoterule}{}
    \footnotetext{\hspace{-2pt}\@firstpagefootnote}%
    \endgroup
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIGURES AND TABLES
\captionsetup[table]{labelfont=bf}
\captionsetup[figure]{labelfont=bf}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFINE THE ABSTRACT ENVIRONMENT
\renewenvironment{abstract}{%
  \normalsize 
  \begin{center}
    \bfseries Abstract
  \end{center}
  \small
  \quotation\par\noindent\ignorespaces
}{
  {\\\\\textbf{Keywords:} \@keywords}
  \endquotation
  \vspace{1em}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEFINE THE SECTION, SUBSECTION, and SUBSUBSECTION FORMATS
\renewcommand{\section}{\@startsection{section}{1}{\z@}%
  {-3.5ex \@plus -1ex \@minus -.2ex}%
  {1ex \@plus .2ex}%
  {\normalfont\large\bfseries}}

% command to deal with unnumbered sections such as 'References'
\renewcommand{\@seccntformat}[1]{\csname the#1\endcsname\quad}

\renewcommand{\subsection}{\@startsection{subsection}{1}{\z@}%
  {-3.5ex \@plus -1ex \@minus -.2ex}
  {1ex \@plus .2ex}
  {\normalfont\normalsize\bfseries}
}

\renewcommand{\subsubsection}{\@startsection{subsubsection}{1}{\z@}%
  {-1.5ex \@plus -1ex \@minus -.2ex}
  {1ex \@plus .2ex}
  {\normalfont\normalsize\itshape}
}

\newcommand{\@expandauthor}[1]{%
  \expandafter\ifx\csname author@orcid@#1\endcsname\relax
    \expandafter\ifx\csname author@email@#1\endcsname\relax
      #1%
    \else
      #1%
    \fi
  \else
    #1%
  \fi
}

\renewcommand{\maketitle}{%
  \begin{center}
    {\LARGE \bfseries \@title \par}
    \vspace{1em}
    \if@final
        {\large
          \begingroup
            \@buildauthornamescorrectly
          \endgroup
        \par}
        \vspace{0.5em}
        \small
        \@affillist
    \else
        {\large Anonymous Submission}
        \vspace{0.5em}
    \fi
  \end{center}
}

\newcounter{@tempcnta}
\newcommand{\@buildauthornamescorrectly}{%
  \setcounter{@tempcnta}{1}%
  \@buildauthorloop
}

\newcommand{\@buildauthorloop}{%
  \ifnum\value{@tempcnta}>\value{authorcount}%
  \else
    \ifnum\value{@tempcnta}=1%
      \@buildauthorentry{\arabic{@tempcnta}}%
    \else
      \ifnum\value{@tempcnta}=\value{authorcount}%
        , and \@buildauthorentry{\arabic{@tempcnta}}%
      \else
        , \@buildauthorentry{\arabic{@tempcnta}}%
      \fi
    \fi
    \stepcounter{@tempcnta}%
    \@buildauthorloop
  \fi
}

\newcommand{\@buildauthorentry}[1]{%
  \mbox{\csname author@name@#1\endcsname}\textsuperscript{\csname author@affil@#1\endcsname}%
  \expandafter\ifx\csname author@orcid@#1\endcsname\@empty
  \else
    ~\href{https://orcid.org/\csname author@orcid@#1\endcsname}{\includegraphics[width=8pt]{orcid.png}}%
  \fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BIBLIGRAPHY
\RequirePackage[
  style=numeric,
  giveninits=false,
  sortcites=true,
  backend=biber]{biblatex}
\RequirePackage[american]{babel}
\RequirePackage{csquotes}

% MLA style customizations for biblatex
\DeclareNameAlias{sortname}{family-given}

% Fix the author name format using a simpler approach
\DeclareNameFormat{author}{%
  \ifgiveninits
    {\usebibmacro{name:family-given}
      {\namepartfamily}
      {\namepartgiveni}
      {\namepartprefix}
      {\namepartsuffix}}
    {\usebibmacro{name:family-given}
      {\namepartfamily}
      {\namepartgiven}
      {\namepartprefix}
      {\namepartsuffix}}%
  \usebibmacro{name:andothers}}

% Format titles according to MLA
\DeclareFieldFormat{title}{\mkbibquote{#1\isdot}}
\DeclareFieldFormat[article]{title}{\mkbibquote{#1\isdot}}
\DeclareFieldFormat[book]{title}{\mkbibemph{#1\isdot}}
\DeclareFieldFormat[thesis]{title}{\mkbibemph{#1\isdot}}
\DeclareFieldFormat[webpage]{title}{\mkbibquote{#1\isdot}}

% Add periods after author names
\renewcommand*{\revsdnamepunct}{\addcomma\space}

% Format journal titles in italics
\DeclareFieldFormat[article]{journaltitle}{\mkbibemph{#1}}

% Format volume and issue numbers according to MLA
\DeclareFieldFormat[article]{volume}{\mkbibemph{#1}}
\DeclareFieldFormat[article]{number}{, no. #1}

% Add period at the end of each entry
\renewbibmacro*{finentry}{\finentry\addperiod}

\DefineBibliographyStrings{english}{%
  editor = {edited by},
  editors = {edited by},
}

\renewbibmacro*{byeditor+others}{%
  \ifnameundef{editor}
    {}
    {\setunit{\addcomma\space}% Changed from \newunit\newblock
     \usebibmacro{byeditor}%
     \clearname{editor}%
     \newunit}%
  \usebibmacro{byeditorx}%
  \usebibmacro{bytranslator+others}}

\endinput
