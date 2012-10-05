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

    def download(type = nil)
      target(type).open('w') {|f| f.write( read ) }
    end

    def delete(type = nil)
      t = target(type) and t.exist? and t.delete
    end      

    def target(type=nil)
      filename= Pathname(path).basename
      type = type || extract_type(filename)
      
      case type
      when :js, :coffee
        Rails.root.join("vendor/assets/javascripts/#{filename}")
      when :css, :scss, :less
        Rails.root.join("vendor/assets/stylesheets/#{filename}")
      when :img, :png, :gif, :jpeg
        Rails.root.join("vendor/assets/images/#{filename}")
      end
    end

    def extract_type(filename)
      type = Pathname(filename).extname
      type = type.gsub(/\./, "").to_sym
    end
    
    #
    # Depends on yaml files: dont use elsewhere
    #
    def write_all
      [:js, :css, :img].each do |type|
        where(spec[type]).download(type) if spec[type]
      end
    end
    alias install write_all

    def delete_all
      [:js, :css, :img].each do |type|
        where(spec[type]).delete(type) if spec[type]
      end
    end
    alias remove delete_all
  end
end
