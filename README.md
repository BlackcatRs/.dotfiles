To find out the default app for a particular type of file

> xdg-mime query filetype Documents/test.pdf

    application/pdf

To find out the mime for the extension

> xdg-mime query default application/pdf

    okularApplication_pdf.desktop

to set default app for an mimetype

> xdg-mime default zathura.desktop application/pdf
to test if applied successfully

> xdg-open test.md



Make zathura the default pdf viewer

Ensures, for example, that xdg-open(1) will open pdf files with zathura.

First, ensure a desktop entry for zathura exists at /usr/share/applications/org.pwmt.zathura.desktop. If it does not, download the desktop entry from from the zathura repo to /usr/share/applications/org.pwmt.zathura.desktop.

Then, set zathura as default using xdg-mime(1)

$ xdg-mime default org.pwmt.zathura.desktop application/pdf



________________________________
Emacs :
To find unbalanced parenthesis
run check-parens 
   