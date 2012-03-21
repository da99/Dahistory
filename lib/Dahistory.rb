require 'Dahistory/version'

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
      @file = nil
      file!(file_path) if file_path
      dirs         './history'
      pending_dir  './pending'
      yield(self) if block_given?
    end

    old_meths = public_instance_methods

    def file path
      @file = File.expand_path(path)
    end

    def dirs *args
      @dirs = args.flatten.map { |dir| File.expand_path dir }
    end

    def pending_dir dir 
      @pending_dir = File.expand_path(dir)
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

          if args.empty?

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

    def backup_file str = :RETURN
      if str == :RETURN
        @backup_file ||= "#{`hostname`.strip}-#{file.gsub('/',',')}.#{Time.now.utc.strftime "%Y.%m.%d.%H.%M.%S"}"
        return File.join( pending_dir, @backup_file )
      end

      @backup_file = str
    end

    def save 

      content  = File.read(file)
      standard = content.gsub("\r", '')

      old = self.class.find_file_copy file, dirs

      if !old
        File.write(backup_file, content) unless self.class.find_file_copy(file, pending_dir)
        raise Pending, backup_file
      end

    end # === def
    
  end # === Base
  
  include Base
  
  class << self
    
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
    
  end # === class

end # === class Dahistory

