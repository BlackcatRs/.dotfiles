# Projectile #

C-p p is a prefix.
C-p p f find file using fuzzy match 
C-p p p find all project within specified directory 

Set the dir local variable which contain value that is porper to that folder only, for an example we can set a value for projectile-project-run-cmd value which execute code in a current folder or when we press C-p p u to run project.

To do so run C-p p e and select projectile-project-run-cmd and give it a value that run the code, e.g npm start. and every time we press the C-p p u it execute the command npm start


# Ivy #
In ivy mini-buffer alt-o show default actions
C-c C-o ivy search result into a buffer and from that buffer we can press enter that will jump to a file. or press o to show all ivy actions
press q to close that buffer.



# Counsel-projectile #
we can search for  a string inside all file within a folder using counsel-projectile-rg (C-p p s r) function which uses ripgrep (rg) program as backend which is a implementation of grep in rust
So first install ripgrep


# Magit #
Get status of files: 
magit-status

Head:     main Remove shell-color-scripts from stow
This above line is indicating that the head of local repository we are in "main" branch and very recent commit on that branch is "Remove shell-color-scripts from stow"


Merge:    origin/main Remove shell-color-scripts from stow
