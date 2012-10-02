module Jail  
  # This is a wrapper around ::Github 
  class Github
    attr_accessor :github, :name, :repo, :path, :spec

    # not memoizing for now
    def self.githublist
      @githublist = ::YAML.load_file(Jail::Engine.root.join("config", "prisoners.yml")).to_hash
    end

    def self.all
      githublist.keys
    end

    # Use this to initialize Github
    def self.find(aname, arepo, apath = nil)
      self.new.tap do |yo|
        yo.name= aname
        yo.repo= arepo
        yo.path= apath
        yo.spec= githublist["#{yo.name}/#{yo.repo}"]
      end
    end

    # Sets github attr which holds the Github (API) instance
    # used by repo, contents, readme etc
    def initialize
      @github = defined?(Jail::LOGIN) ? 
                  ::Github.new({ :basic_auth => Jail::LOGIN }) :
                  ::Github.new
    end

    def repos
      github.repos.get(name, repo)
    end

    def contents
      self.path ||= "/"
      github.repos.contents.get(name, repo, path)
    end

    # TODO : split in 2 methods for consistency
    def readme
      text = Base64.decode64 github.repos.contents.readme(name, repo).content
      github.markdown.render :text => text
    end

    def read(path)
      # TODO : raise error if path's not a file
      self.path= path
      text = Base64.decode64 contents.content
    end

    def install
      #contents._links[:git]
      download(:js)
      download(:css)
      download(:img)
    end

    private
    def download(type = :js)
      return if spec[type].blank?
      target(type).open('w') {|f| f.write( read(spec[:type]) )}
    end

    def target(type)
      filename= Pathname(path).basename.to_s
      case type
      when :js
        Rails.root.join("vendor/assets/javascripts/#{filename}")
      when :css
        Rails.root.join("vendor/assets/stylesheets/#{filename}")
      when :img
        Rails.root.join("vendor/assets/images/#{filename}")
      end
    end

  end
end
