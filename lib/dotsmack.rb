require 'rubygems'
require 'find'

#
# Dotsmack - File, dotignore, and dotconfig scanner.
#
# Scans for files recursively.
#
# Searches for dotfiles in:
#
# * The same directory as path
# * An ancestor directory, up to $HOME
# * If path is not $HOME-relative, search only $HOME
#
# dotignore assumes fnmatch format.
# dotconfig may be in any format.
#
module Dotsmack
  HOME = File.expand_path(ENV['HOME'])
  PARENT_OF_HOME = File.expand_path('..', HOME)

  FNMATCH_FLAGS =
    File::FNM_DOTMATCH | # Allow matching on Unix hidden dotfiles
    File::FNM_EXTGLOB    # Allow matching with {..., ...} group patterns

  #
  # More intuitive behavior for fnmatch
  #
  def self.fnmatch?(pattern, path)
    # Assume non-directory path
    if File.fnmatch(pattern, path, FNMATCH_FLAGS) ||
        File.fnmatch("**#{File::SEPARATOR}#{pattern}", path, FNMATCH_FLAGS)
      true
    # Consider path as directory
    else
      path =
        if path.end_with?(File::SEPARATOR)
          path
        else
          "#{path}#{File::SEPARATOR}"
        end

      pattern =
        if pattern.end_with?(File::SEPARATOR)
          "#{pattern}*"
        else
          "#{pattern}#{File::SEPARATOR}*"
        end

      File.fnmatch(pattern, path, FNMATCH_FLAGS) ||
        File.fnmatch("**#{File::SEPARATOR}#{pattern}", path, FNMATCH_FLAGS)
    end
  end

  #
  # Smacker dotfile scanner/enumerator.
  #
  class Smacker
    attr_accessor :dotignore, :dotconfig, :additional_ignores, :path2ignore, :path2config

    #
    # Create a Smacker dotfile scanner/enumerator.
    #
    # @dotignore Filename for ignore patterns (optional)
    # @dotconfig Filename for configuration (optional)
    #
    def initialize(dotignore = nil, additional_ignores = [], dotconfig = nil)
      @dotignore = dotignore
      @dotconfig = dotconfig
      @additional_ignores = additional_ignores

      @path2dotignore = {}
      @path2dotconfig = {}

      if !dotignore.nil?
        home_dotignore = "#{HOME}#{File::SEPARATOR}#{dotignore}"

        @path2dotignore[PARENT_OF_HOME] = []

        @path2dotignore[HOME] =
          if File.exist?(home_dotignore)
            open(home_dotignore).read.split("\n")
          else
            []
          end
      end

      if !dotconfig.nil?
        home_dotconfig = "#{HOME}#{File::SEPARATOR}#{dotconfig}"

        @path2dotconfig[PARENT_OF_HOME] = nil

        @path2dotconfig[HOME] =
          if File.exist?(home_dotconfig)
            open(home_dotconfig).read
          else
            nil
          end
      end
    end

    #
    # Scan for dotignore.
    #
    # Assumes dir is an absolute path.
    # Assumes dir is not a symlink.
    # Assumes dir is $HOME-relative.
    #
    def scan_for_dotignore!(dir)
      if @path2dotignore.has_key?(dir)
        @path2dotignore[dir]
      else
        candidate = "#{dir}#{File::SEPARATOR}#{@dotignore}"

        dotignore =
          if File.exist?(candidate)
            open(candidate).read.split("\n")
          else
            []
          end

        parent = File.expand_path('..', dir)

        # Determine parent dotignore
        parents_dotignore = scan_for_dotignore!(parent)

        # Merge candidate and parent information
        dotignore.concat(parents_dotignore)

        @path2dotignore[dir] = dotignore

        dotignore
      end
    end

    #
    # Scan for dotconfig.
    #
    # Assumes dir is an absolute path.
    # Assumes dir is not a symlink.
    # Assumes dir is $HOME-relative.
    #
    def scan_for_dotconfig!(dir)
      if @path2dotconfig.has_key?(dir)
        @path2dotconfig[dir]
      else
        candidate = "#{dir}#{File::SEPARATOR}#{@dotconfig}"

        parent = File.expand_path('..', dir)

        # Use first dotconfig found.
        dotconfig =
          if File.exist?(candidate)
            open(candidate).read
          else
            scan_for_dotconfig!(parent)
          end

        @path2dotconfig[dir] = dotconfig

        dotconfig
      end
    end

    #
    # Determines whether path is dotignored.
    #
    def ignore?(path)
      path = File.absolute_path(path)

      dir =
        if File.directory?(path)
          path
        else
          File.expand_path('..', path)
        end

      relative_to_home = dir.start_with?(HOME)

      if !relative_to_home
        dir = HOME
      end

      scan_for_dotignore!(dir)

      (@path2dotignore[dir] + @additional_ignores).any? do |pattern|
        Dotsmack::fnmatch?(pattern, path)
      end
    end

    #
    # Returns dotconfig for path.
    #
    def config(path)
      path = File.absolute_path(path)

      dir =
        if File.directory?(path)
          path
        else
          File.expand_path('..', path)
        end

      relative_to_home = dir.start_with?(HOME)

      if !relative_to_home
        dir = HOME
      end

      scan_for_dotconfig!(dir)

      @path2dotconfig[dir]
    end

    #
    # Recursively enumerate files named or nested in paths array.
    #
    # Skips dotignored files.
    #
    # Returns [file, dotconfig] pairs.
    #
    def enumerate(paths)
      files = []

      paths.each do |path|
        # STDIN idiom
        if path == '-'
          files << [
            path,
            if @dotconfig.nil?
              nil
            else
              config(Dir.pwd)
            end
          ]
        # Skip symlinks
        elsif File.symlink?(path)
          nil
        elsif File.directory?(path) && (@dotignore.nil? || !ignore?(path))
          files.concat(
            enumerate(
              Find.find(path).reject do |p| File.directory?(p) end
            )
          )
        elsif !ignore?(path)
          files << [
              path,
              if @dotconfig.nil?
                nil
              else
                config(path)
              end
          ]
        end
      end

      files
    end
  end
end
