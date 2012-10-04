module Jail  
  # This is a wrapper around ::Github 
  class Github
    attr_reader    :github, :name, :repo, :spec
    attr_accessor  :path
    cattr_accessor :githublist

    def self.add_githublist(yaml_path)
      hash = YAML.load_file(yaml_path).to_hash
      self.githublist= self.githublist.merge(hash)
    end

    self.githublist={}
    add_githublist( Jail::Engine.root.join("config", "jail.jqueryplugins.yml") )

    # TODO : raise if missing descr:
    def self.all
      githublist.group_by {|k, v| v[:descr].match(/\w+:/).to_s if v[:descr]}
    end

    # Uhh useless ? Or AR Sexy ?
    def self.find(name, repo, path = nil)
      new(name, repo).tap do |yo|
        yo.path= path
      end
    end

    def initialize(name, repo)
      @name= name
      @repo= repo
      @spec= self.class.githublist["#{@name}/#{@repo}"]
      @github = defined?(Jail::LOGIN) ?
                  ::Github.new({ :basic_auth => Jail::LOGIN }) :
                  ::Github.new
    end

    # another AR alike for chaining
    def where(path)
      self.path= path
      self
    end

    # do I need this method ?
    def repos
      @repos ||= github.repos.get(name, repo)
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

    def read
      #raise "blah" unless contents.type == "file"
      text = Base64.decode64 contents.content
    end

    def install
      #contents._links[:git]
      download(:js)
      download(:css)
      download(:img)
    end

    def remove
      delete_file(:js)
      delete_file(:css)
      delete_file(:img)
    end

    private
    def download(type = :js)
      return if spec[type].blank?
      text = where(spec[type]).read
      target(type).open('w') {|f| f.write(text) }
    end

    def delete_file(type = :js)
      return if spec[type].blank?
      self.path = spec[type]
      t = target(type) and t.exist? and t.delete
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
