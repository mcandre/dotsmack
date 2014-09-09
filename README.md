# dotsmack - a library for modern, per-directory dotfile configuration

# HOMEPAGE

https://github.com/mcandre/dotsmack

# RUBYGEMS

https://rubygems.org/gems/dotsmack

# ABOUT

Dotsmack is a Ruby library for adding modern dotfile customization to your Ruby applications.

* dotignore files - [fnmatch](http://man.cx/fnmatch) syntax, like `.gitignore`
* dotconfig files - any format (getoptlong, YAML, JSON, ...)
* Searches for dotfiles in `.`, `..`, etc., up to `$HOME`.

# EXAMPLES

```
$ tree -a examples/twitch/
examples/twitch/
├── bin
│   └── twitch
└── test
    ├── .twitchignore
    ├── a-tale-of-two-cities.txt
    ├── embiggened
    │   └── beginning-programming-with-java-for-dummies.txt
    ├── fahrenheit-451.txt
    ├── shortened
    │   └── beginning-programming-with-java-for-dummies.txt
    └── supertwitter
        ├── .twitchrc.yml
        ├── README.md
        └── beginning-programming-with-java-for-dummies.txt

5 directories, 9 files

$ head examples/twitch/bin/twitch 
#!/usr/bin/env ruby

#
# Tweet validator
#

require 'rubygems'
require 'dotsmack'
require 'yaml'

$ examples/twitch/bin/twitch examples/twitch/test/
examples/twitch/test/a-tale-of-two-cities.txt: 614
```
