A collection of vim plugins, scripts, etc. that I use every day for coding, writing documents, and hacking around.

This is not meant to be the "one true vim config", and I'm finding newer and better ways to do things every day. However, I have found that using vim pathogen as a sort of "plugin manager" for vim to be very useful. Often a new vim plugin can be added with only 2 commands:

 git submodule add <url> bundle/plugin-folder
 git submodule update --init

Some legacy plugins and scripts are also included in the standard vim-runtime folder structure.

To install and use these vim plugins, simply run the setup script in the root folder. It will create a symlink to the setup.vim script as your local .vimrc
