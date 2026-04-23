Moving
```
h,j,k,l - cursor


0 - beginning of the line
$ - end of the line
b - beginning of the word
e - end of the word


gg      - top
shift+g - bottom 


ctrl+u - half screen up
ctrl+d - half screen down
ctrl+y - mode up cursor in place
ctrl+e - move down cursor in place


% - matching bracket 


ctrl+g - status
1ctrl+g - full status
{number}G moves to the line number


dd - delete line
dG - delete until the end of the file


:e - edit file
```

Exit
```
shift+Zshift+Z - exit with saving
shift+Zshift+Q - exit without saving
:q, :quit - quit the current window
:q! - exit without saving
:qa - exit all unless there are changes
:qa! - exit all without saving
:wq! - write and exit
```

Changes
```
a - append
A - append at the line end
i - insert
I - insert at the line start
o - append below
O - append line above


u - undo 
U - undo all changes on a line
ctrl+r - redo

dd - delete line
dw - delete to the start of the next word
de - delete to the end of the word 
d$ - delete to the end of the line
```

Search
```
:noh - clear search highlights
```

Windows
```
ctrl+wh - split horizontally
ctrl+wv - split vertically
ctrl+wc - window close
ctrl+w[hjkl] - move between windows
ctrl+ww - next window
ctrl+w+ - increase height
ctrl+w 10+ - increase height
ctrl+w- - decrease height
ctrl+w= - equal size
ctrl+w > - increase width
ctrl+w < - decrease width
ctrl+w 10+ increase width
ctrl+w _ - maximum height
ctrl+w | - maximum width
:res 10 - set height
:res +10 - increase height
:vertical resize 200 - set width 
:vertical resize +10 - increase width
```

Tabs
```
:tabedit - edit in tab
gt - move to the next 
gT - move to the previous 
:tabs - close tab
```

Visual
```
v - visual mode
V - visual with line selection
ctrl+v - visual block mode
y - copy
p - paste
x - cut
```

Command line
```
!ls - list current dir

```

Plugins (https://vimawesome.com/)
```
ctrl+p - fuzzy search for the file
,ne - NERDTree
fzf - fuzzy search
```

NERDTree
```
Press o to open the file in a new buffer or open/close directory. 

Press t to open the file in a new tab. 

Press i to open the file in a new horizontal split. 

Press s to open the file in a new vertical split. 

Press p to go to parent directory. 

Press r to refresh the current directory. 

Press m to launch NERDTree menu inside Vim. 
```
