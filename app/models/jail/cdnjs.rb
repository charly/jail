module Jail
  class Cdnjs
    attr_reader :github, :root_path, :package_path
    delegate    :name, :filename, :version, :description,
                :homepage, :repositories, :maintainers, :to => :package #etc

    def self.github
      @github ||= Jail::Github.find("cdnjs", "cdnjs", "ajax/libs")
    end

    def self.libs
      @libs ||= github.contents
    end
    libs # load & memoize cdnjs libraries

    def self.lib(path)
      github.where(path).contents
    end

    def self.find_path(name)
      hash = libs.find { |hashie| hashie.path.split("/").last == name }
      hash and hash.path # raise if not found ?
    end

    def self.find(name)
      path = find_path(name)
      lib = lib(path)

      self.new(path, lib)
    end

    def initialize(path, lib)
      @github       = self.class.github
      @root_path    = path
      @package_path = lib.find {|h| h.type == "file"}.path
    end

    def package
      @package ||= Hashie::Mash.new ActiveSupport::JSON.decode( github.where(package_path).read )
    end

    # gets the version from the package.json & returns a path
    def version_path
      Pathname(root_path).join(version)
    end

    def files
      @files ||= github.where(version_path).contents
    end

    def file(name)
      github.where(version_path.join(name))
    end

    def mapped_files
      files.map(&:name).group_by {|name| Pathname(name).extname }
    end

    def install(params)
      files_to_write = params.map {|file, num| file if num == "1"}.compact!

      files_to_write.each do |name|
        file(name).download()
      end
    end

  end
end
