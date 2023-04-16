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
merge section indicates what have been merged.

? = interactive git related actions
s = stage a file 
S = stage all file 
select the text and press s to stage only the selected text 

u= unstage file 
U= unstage all file 

c = show related commit actions 
cc= commit the changes and C-c k abort committing process.
cF = add a changes to already pushed commit.


b = show branch related action
bs = reset the last commit from actual branch and create new branch with that changes.

z = stash related action

P = push related commands 
Pf = force push can be done if local git history does not match with remote

r= rebase related actions 
ri= rebase interactively

# Org mode #
shift alt up = move heading heading 
C-c C-x C-b check the check box
C-c C-d org deadline (This show in agenda view to remember the upcoming task)
C-c . = set a timestamp (this can be extended with repeated-task, this can be achieve with a special syntax. +1y repeat every year on the specified date and month )
C-c C-q to select interactivly tags
OR counsel-org-tag and press alt+enter to select multiple tags
C-c C-t select state

org-agenda = show agenda with scheduled items
org-agenda t = show TODO items or 2r =  to show DONE items


## Footnote ##
C-c C-x f create new footnote or if the cursor is in an already created footnote then it will jump to the definition of that footnote.
org-footnote-normalize reorder footnotes id number (if you delete a footnote and the id number is not updated then it will update)

## Internal links ##
Use the property -  #+NAME: name_of_the_link
to link -           [[name_of_the_link]]

OR

Use the property -  #+CUSTOM_ID: name_of_the_id
to link -           [[name_of_the_id]]

OR
to link -           [[*name_of_the_heading]]

OR
1. one item
2. <<target>>another item
Here we refer to item [[target]].




# Org-roam #
C-c n f find a node or if not exist then it create a node with specified name
C-c n i link a another node inside a node and if node exist it will create it and link it
C-c n l Show backlinks which means show the nodes that have links to the current node.


Inside `[[]]` run `completion-at-point` at point will show prompt with nodes to link
Type a first letters of node and type `C-M-i` to prompt.
Make a heading inside a node file as a node with `org-id-get-create` function which add PROPERTIES to that heading.



# Org agenda #
C-c a t = we can filter using states

Make a task or an event to pop up every year using +1y
<2023-04-16 dim +1y>
More info https://orgmode.org/manual/Repeated-tasks.html



Making query based on tags and display them in org agenda view
query based on properties that have been set that file or task
Or can also use https://github.com/alphapapa/org-ql


counsel-org-tag allow to choose tags that have been already used in that file from where u evoke this command

C-c C-q open commonly known task which we defined in emacs config file

We can use traditional capture template or Declarative Org Capture Templates (DOCT) to capture tasks
https://github.com/progfolio/doct

C-c C-q or org-set-tags-command to choose assign a tag

org-refile to move finished items or task

add a tesk with `STYLE: habit` inside `PROPERTY` to get track of your habits
