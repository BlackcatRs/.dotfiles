# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import *
from ranger.core.loader import CommandLoader

# Provides all hash algorithms (sha256, blake2b, etc.)
import hashlib       
# Creates temporary files safely
import tempfile
# a dict that auto-creates missing keys
from collections import defaultdict

# A simple command for demonstration purposes follows.
#------------------------------------------------------------------------------

# You can import any python module as needed.
import os

# Any class that is a subclass of "Command" will be integrated into ranger as a
# command.  Try typing ":my_edit<ENTER>" in ranger!
class my_edit(Command):
    # The so-called doc-string of the class will be visible in the built-in
    # help that is accessible by typing "?c" inside ranger.
    """:my_edit <filename>

    A sample command for demonstration purposes that opens a file in an editor.
    """

    # The execute method is called when you run this command in ranger.
    def execute(self):
        # self.arg(1) is the first (space-separated) argument to the function.
        # This way you can write ":my_edit somefilename<ENTER>".
        if self.arg(1):
            # self.rest(1) contains self.arg(1) and everything that follows
            target_filename = self.rest(1)
        else:
            # self.fm is a ranger.core.filemanager.FileManager object and gives
            # you access to internals of ranger.
            # self.fm.thisfile is a ranger.container.file.File object and is a
            # reference to the currently selected file.
            target_filename = self.fm.thisfile.path

        # This is a generic function to print text in ranger.
        self.fm.notify("Let's edit the file " + target_filename + "!")

        # Using bad=True in fm.notify allows you to print error messages:
        if not os.path.exists(target_filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        # This executes a function from ranger.core.acitons, a module with a
        # variety of subroutines that can help you construct commands.
        # Check out the source, or run "pydoc ranger.core.actions" for a list.
        self.fm.edit_file(target_filename)

    # The tab method is called when you press tab, and should return a list of
    # suggestions that the user will tab through.
    def tab(self):
        # This is a generic tab-completion function that iterates through the
        # content of the current directory.
        return self._tab_directory_content()


# https://github.com/ranger/ranger/wiki/Integrating-File-Search-with-fzf
# Now, simply bind this function to a key, by adding this to your ~/.config/ranger/rc.conf: map <C-f> fzf_select
class fzf_select(Command):
    """
    :fzf_select

    Find a file using fzf.

    With a prefix argument select only directories.

    See: https://github.com/junegunn/fzf
    """
    def execute(self):
        import subprocess
        if self.quantifier:
            # match only directories
            command = (
                r"find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune"
                r" -o -type d -print 2> /dev/null"
                r" | sed 1d"
                r" | cut -b3-"
                r" | fzf +m"
            )
        else:
            # match files and directories
            command=r"find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"

        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)


# fzf_locate
class fzf_locate(Command):
    """
    :fzf_locate

    Find a file using fzf.

    With a prefix argument select only directories.

    See: https://github.com/junegunn/fzf
    """
    def execute(self):
        import subprocess
        if self.quantifier:
            command="locate home media | fzf -e -i"
        else:
            command="locate home media | fzf -e -i"
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)


class fzf_bring(Command):
    """
    :fzf_bring

    Find a file using fzf and bring it to the current directory.

    See: https://github.com/junegunn/fzf
    """
    def execute(self):
        import subprocess
        import shutil
        if self.quantifier:
            # match only directories
            command=r"find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        else:
            # match files and directories
            command=r"find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            shutil.move(fzf_file, self.fm.thisdir.path)


class compress(Command):
    def execute(self):
        """ Compress marked files to current directory """
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        original_path = cwd.path
        parts = self.line.split()
        au_flags = parts[1:]

        descr = "compressing files in: " + os.path.basename(parts[1])
        obj = CommandLoader(args=['apack'] + au_flags + \
                [os.path.relpath(f.path, cwd.path) for f in marked_files], descr=descr)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

    def tab(self):
        """ Complete with current folder name """

        extension = ['.zip', '.tar.gz', '.rar', '.7z']
        return ['compress ' + os.path.basename(self.fm.thisdir.path) + ext for ext in extension]


class extracthere(Command):
    def execute(self):
        """ Extract copied files to current directory """
        copied_files = tuple(self.fm.copy_buffer)

        if not copied_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        one_file = copied_files[0]
        cwd = self.fm.thisdir
        original_path = cwd.path
        au_flags = ['-X', cwd.path]
        au_flags += self.line.split()[1:]
        au_flags += ['-e']

        self.fm.copy_buffer.clear()
        self.fm.cut_buffer = False
        if len(copied_files) == 1:
            descr = "extracting: " + os.path.basename(one_file.path)
        else:
            descr = "extracting files from: " + os.path.basename(one_file.dirname)
        obj = CommandLoader(args=['aunpack'] + au_flags \
                + [f.path for f in copied_files], descr=descr)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)


# The class name becomes the ranger command — you type :hash_selected
# in ranger or bind it to a key
class calculate_hash(Command):
    """:hash_selected
    Hash all selected files, show duplicates, and optionally delete them via fzf.
    """

    def execute(self):
        # self.fm — the ranger file manager instance, gives access to
        # everything
        # self.fm.thistab — the currently active tab
        # get_selection() — returns marked files, or just the file
        # under cursor if nothing is marked
        # if f.is_file — skips directories
        # result is a plain list of file path strings
        files = [f.path for f in self.fm.thistab.get_selection()
                 if f.is_file]

        # notify() shows a message in ranger's bottom bar
        # bad=True makes it red
        if not files:
            self.fm.notify("No files selected!", bad=True)
            return

        # defaultdict(list) — a dict where every new key automatically starts
        # as an empty list, so .append() never fails on a missing key
        # after the loop, hashes looks like:
        # {
        #   "abc123...": ["file1.txt"],
        #   "fff999...": ["file2.jpg", "file3.jpg"],  # duplicates share the same hash
        # }
        hashes = defaultdict(list)
        for path in files:
            digest = self._hash_file(path)
            hashes[digest].append(path)


        # Exit if no duplicate files
        duplicates = {h: p for h, p in hashes.items() if len(p) > 1}
        if not duplicates:
            self.fm.notify("✓ No duplicates found.", bad=False)
            return

        # Build fzf input: only duplicate files, annotated with their
        # hash
        # lines = [
        #     "[abc123def4]  /foo/a.txt",
        #     "[abc123def4]  /bar/a.txt",
        #     "[ghi789jkl0]  /a.jpg",
        #     "[ghi789jkl0]  /b.jpg"
        # ]
        lines = []
        for digest, paths in duplicates.items():
            for p in paths:
                short_hash = digest[:12]
                lines.append(f"[{short_hash}]  {p}")

        self._pick_and_delete(lines)
        self.fm.reload_cwd()  # refresh ranger after deletion

    def _hash_file(self, path, algo="sha256"):
        h = hashlib.new(algo)
        with open(path, "rb") as f:
            for chunk in iter(lambda: f.read(65536), b""):
                h.update(chunk)
        return h.hexdigest()

    def _pick_and_delete(self, lines):
        # join → list to string :
        # "\n".join(["a", "b", "c"])  # "a\nb\nc"
        input_text = "\n".join(lines)

        with tempfile.NamedTemporaryFile("w", suffix=".txt",
                                         delete=False) as tmp:
            tmp.write(input_text)
            tmp_path = tmp.name

        # Path to file that contain selected files for deletion
        out_path = tmp_path + ".selected"

        # fzf: multi-select with Tab, header instructions, preview the path
        fzf_cmd = (
            f"cat {tmp_path} | fzf --multi "
            f"--header='TAB to select duplicates to DELETE — ENTER to confirm — ESC to cancel' "
            f"--prompt='Delete > ' "
            f"> {out_path}"
        )

        self.fm.run(fzf_cmd)

        # Read selected files and delete
        if os.path.exists(out_path):
            with open(out_path) as f:
                selected = [line.strip() for line in f if line.strip()]

            deleted = 0
            for line in selected:
                # Extract path after the "[hash]  " prefix
                # Ex:
                # line = "[abc123def4]  /foo/a.txt"

                # split on "] " and the , 1 means split only once, so
                # paths containing "] " won't break.
                # line.split("]  ", 1)
                # → ["[abc123def4", "/foo/a.txt"]

                # line.split("]  ", 1)[-1]  # take the last element
                # → "/foo/a.txt"
                path = line.split("]  ", 1)[-1]
                
                if os.path.isfile(path):
                    os.remove(path)
                    deleted += 1

            self.fm.notify(f"🗑 Deleted {deleted} file(s)." if deleted else "Nothing deleted.")

        os.unlink(tmp_path)
        if os.path.exists(out_path):
            os.unlink(out_path)
