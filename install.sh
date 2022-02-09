#! /bin/bash

# .bashrc
test -f $(pwd)/.bashrc && echo >> ~/.bashrc && echo source $(pwd)/.bashrc >> ~/.bashrc

# .bash_aliases
test -f $(pwd)/.bash_aliases && echo >> ~/.bash_aliases && echo source $(pwd)/.bash_aliases >> ~/.bash_aliases

# .dircolors
test -f $(pwd)/.dircolors && ln -sf $(pwd)/.dircolors ~/.dircolors
