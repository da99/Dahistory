require 'Dahistory/version'
require 'Exit_0'

def Dahistory file = nil
  da = Dahistory.new { |o| 
    o.file(file) if file
    yield(o)     if block_given?
  }

  da.save
  da
end # === def

class Dahistory
 
  Pending = Class.new(RuntimeError)

  module Base
    
    def initialize file_path = nil
      @git = false
      @file = nil
      file!(file_path) if file_path
      dirs         []
      history      './history'
      pending_dir  './pending'
      @on_raise_pending = nil
      yield(self) if block_given?
    end

    old_meths = public_instance_methods

    def file path
      @file = File.expand_path(path)
    end

    def dirs *raw
      @dirs = raw.flatten.map { |dir| File.expand_path dir }
    end

    def history raw
      @history = File.expand_path raw 
    end

    def pending_dir dir 
      @pending_dir = File.expand_path(dir)
    end

    def on_raise_pending &blok
      @on_raise_pending = blok
    end

    # 
    #  My alternative to :attr_accessors:
    #
    #  Previous methods were setters.  
    #  Alias the methods as #{name}_set
    #  and create reader/setter methods.
    #
    (public_instance_methods - old_meths ).each { |name| 

      alias_method :"#{name}_set", name

      eval %~
        def #{name} *args, &blok

          if args.empty? && !block_given?

            unless instance_variable_defined?(:@#{name})
              raise ArgumentError, "Instance variable not set: @#{name}"
            end
            @#{name}

          else

            #{name}_set(*args, &blok)

          end

        end # === def
      ~

    }

    def backup_basename
      File.basename( backup_file )
    end

    def backup_file str = :RETURN
      if str == :RETURN
        @backup_file ||= "#{`hostname`.strip}-#{file.gsub('/',',')}.#{Time.now.utc.strftime "%Y.%m.%d.%H.%M.%S"}"
        return File.join( pending_dir, @backup_file )
      end

      @backup_file = str
    end

    def git_add_commit
      @git = :commit
    end

    def git_add_commit_push args = ""
      @git = args
    end

    def git_it path 
      return false unless @git
      Exit_0 "git add #{path}"
      Exit_0 %! git commit -m "Backup: #{backup_file}"!

      if @git.is_a?(String)
        Exit_0 %! git push #{@git} !
      end
    end

    def save 

      content  = File.read(file)
      standard = content.gsub("\r", '')

      in_dirs    = self.class.find_file_copy file, dirs
      in_history = self.class.find_file_copy file, history
      in_pending = self.class.find_file_copy file, pending_dir

      return true if in_history

      if in_dirs
        path = File.join(history, backup_basename)
        File.write(path, content)
        git_it path 
        return true
      end
      
      if !in_pending

        File.write(backup_file, content) 

        git_it backup_file

      end # === if !in_pending

      on_raise_pending.call if on_raise_pending
      raise Pending, backup_file

    end # === def
    
  end # === Base
  
  include Base
  
  module Class_Methods
    
    def find_file_copy file, *raw_dirs
      standard = File.read(file).gsub("\r", "")
      found    = nil
      dirs     = raw_dirs.flatten
      
      dirs.each { |path| 
        full = File.join( File.expand_path(path), "/*")
        files = Dir.glob( full, File::FNM_DOTMATCH ).select { |unk| File.file?(unk) }

        found = files.detect { |f| 
          raw = File.read(f)
          raw.gsub("\r", "") == standard
        }

        break if found
      }

      found
    end # === def
    
  end # === module Class_Methods

  extend Class_Methods

end # === class Dahistory

