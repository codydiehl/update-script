# update-script
Interactive all-in-one Update script for MacOS

An all in one update script for my macOS

Covering things like homebrew, pip, vim plug, node.js, npm, gem, mac software update, zprezto, etc. 

Would like to extend to other operating systems, linux especially. there is a few minor linux checks on the scripts so far, but nothing special yet. 
this is very much work in progress, and really just a learning experience with understanding bash scripting. 
Learning a lot about it as this is my first script and I am hundreds of lines in with many difffernt problem solving checks and variables and functions, etc. 

________________________________________________
Example of running update script on a mac system. 
Each check makes sure each command is installed first. It should work just fine on a mac os system. 


```
~/git/update-script master*
❯ ./update.sh
Platform is MacOS
================================
 Zsh Prezto Update
================================

-Updating Zprezto and its Plugins-
remote: Counting objects: 3, done.
remote: Total 3 (delta 2), reused 2 (delta 2), pack-reused 1
Unpacking objects: 100% (3/3), done.
From https://github.com/sorin-ionescu/prezto
 * [new branch]      belak/zdebuglog -> origin/belak/zdebuglog
There are no updates.

================================
 Update HomeBrew
================================

-Updating Homebrew Components-
Updated 1 tap (homebrew/core).
==> Updated Formulae
libgtop

-Checking Outdated Packages-
d12frosted/emacs-plus/emacs-plus (HEAD-5fd2297) < latest HEAD [pinned at HEAD-5fd2297]

-Do you want to update Outdated Packages? (y/n)- y
Upgrading outdated packages...
==> No packages to upgrade
Error: Not upgrading 1 pinned package:
d12frosted/emacs-plus/emacs-plus HEAD-5fd2297

-Listing old unnecessary packages-

-Do you want to cleanup the old packages? (y/n)- y
Cleaning up old packages...

================================
 Update MacOS Software and OS
================================

-Checking macOS Software Updates-
No new software available.
Software Update Tool

Finding available software

Skipping softwareupdate...


================================
 Update Python pip Packages
================================

-Check for all installed pip packages-
click
colorama
Glances
kaptan
libtmux
psutil
Pygments
PyYAML
tmuxp

-Do you want to attempt to update the above pip packages? (y/n)- y
Updating pip packages...
Requirement already up-to-date: click in /Users/codydiehl/Library/Python/2.7/lib/python/site-packages
Requirement already up-to-date: colorama in /Users/codydiehl/Library/Python/2.7/lib/python/site-packages
Requirement already up-to-date: Glances in /usr/local/lib/python2.7/site-packages
Requirement already up-to-date: psutil>=2.0.0 in /usr/local/lib/python2.7/site-packages (from Glances)
Requirement already up-to-date: kaptan in /Users/codydiehl/Library/Python/2.7/lib/python/site-packages
Requirement already up-to-date: PyYAML==3.12 in /Users/codydiehl/Library/Python/2.7/lib/python/site-packages (from kaptan)
Requirement already up-to-date: libtmux in /Users/codydiehl/Library/Python/2.7/lib/python/site-packages
Requirement already up-to-date: psutil in /usr/local/lib/python2.7/site-packages
Requirement already up-to-date: Pygments in /usr/local/lib/python2.7/site-packages
Requirement already up-to-date: PyYAML in /Users/codydiehl/Library/Python/2.7/lib/python/site-packages
Requirement already up-to-date: tmuxp in /Users/codydiehl/Library/Python/2.7/lib/python/site-packages
Requirement already up-to-date: colorama==0.3.9 in /Users/codydiehl/Library/Python/2.7/lib/python/site-packages (from tmuxp)
Requirement already up-to-date: libtmux==0.7.7 in /Users/codydiehl/Library/Python/2.7/lib/python/site-packages (from tmuxp)
Requirement already up-to-date: kaptan>=0.5.7 in /Users/codydiehl/Library/Python/2.7/lib/python/site-packages (from tmuxp)
Requirement already up-to-date: click==6.7 in /Users/codydiehl/Library/Python/2.7/lib/python/site-packages (from tmuxp)
Requirement already up-to-date: PyYAML==3.12 in /Users/codydiehl/Library/Python/2.7/lib/python/site-packages (from kaptan>=0.5.7->tmuxp)

================================
 Update NPM and Packages
================================

-Check if npm update is needed-
Already the current version of npm: 5.6.0

-Check for npm-check package-
npm-check is already installed...

-Update npm Packages with npm-check-
The global path you are searching is: /usr/local/lib/node_modules
⠋ Checking for unused packages. --skip-unused if you don't want thYour modules look amazing. Keep up the great work.

================================
 Update Node.JS
================================

-Preferred method to manage node.js-
Do you want to manage node.js with nvm? (y/n) y
Using nvm to manage node.js...

-Checking if nvm is already installed-
nvm is already installed...

-Install latest node.js via nvm-
Already have the latest version of node.js: 9.5.0

================================
 Update RubyGems
================================
-Checking for rubygems update-
ruby gem does not need to be updated...

Current version: 2.7.5

-Displaying out of date ruby gems-
Nothing to update...

================================
 Update Vim Plugins
================================

-Update Vim Plugins-

note: vim buffers will remain open
close when finished with :q

vimplug is installed..

Found VimPlug dir in: /Users/codydiehl/.vim/plugged

-Update VimPlug-

Updating VimPlug...

Updating vim plugins...
```
