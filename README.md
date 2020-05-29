# dotsmack - a library for modern, per-directory dotfile configuration

dotsmack is a customizable framework for managing per-project configuration files.

# EXAMPLE

```console
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

$ examples/twitch/bin/twitch < examples/twitch/test/a-tale-of-two-cities.txt
-: 614
```

# HOMEPAGE

https://github.com/mcandre/dotsmack

# RUBYGEMS

https://rubygems.org/gems/dotsmack

# ABOUT

Dotsmack is a Ruby library for adding modern dotfile customization to your Ruby applications.

* Recursive file scanning, like `jshint .`
* dotignore files - [fnmatch](http://man.cx/fnmatch) syntax, like `.gitignore`
* dotconfig files - any format (getoptlong, YAML, JSON, ...)
* Searches for dotfiles in `.`, `..`, etc., up to `$HOME`.

More examples:

* [aspelllint](https://github.com/mcandre/aspelllint)
* [enlint](https://github.com/mcandre/enlint)
* [cowl](https://github.com/mcandre/cowl)
* [gtdlint](https://github.com/mcandre/gtdlint)
* [lili](https://github.com/mcandre/lili)

# REQUIREMENTS

* [ruby](https://www.ruby-lang.org/) 2.7+

## Optional

* [GNU findutils](https://www.gnu.org/software/findutils/)
* [stank](https://github.com/mcandre/stank) (e.g. `go get github.com/mcandre/stank/...`)
* [Python](https://www.python.org) 3+ (for yamllint)
* [Node.js](https://nodejs.org/en/) (for eclint)

# INSTALL

Install via [RubyGems](http://rubygems.org/):

```console
$ gem install aspelllint
```

# LICENSE

FreeBSD

# DEVELOPMENT

## Testing

Keep the interface working:

```console
$ cucumber
```

## Linting

Keep the code tidy:

```console
$ rake lint
```

## Git Hooks

See `hooks/`.
