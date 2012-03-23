
describe "Dahistory" do
  
  it "returns a Dahistory object" do
    file = "files/#{rand 1000}.txt"
    target = rand(10000).to_s
    chdir {
      File.write file, target
      File.write file.sub("files", "history"), target
      o = Dahistory(file)
      o.class.should.be == Object.const_get(:Dahistory)
    }
  end
  
end # === Dahistory

describe "Dahistory: pending file" do

  before { reset_dirs }
  
  it "copies file to pending dir" do
    file = "files/a.txt"
    target = rand(1000).to_s
    chdir {
      File.write(file, target)
      pending = begin
                  Dahistory file
                rescue Dahistory::Pending => e
                  e.message
                end
      name = File.basename(pending)
      File.read(File.join "pending", name).should == target
    }
  end

  it "does not copy file if file is already in ./pending" do
    file = "files/#{rand 1000}.txt"
    target = rand(10000).to_s
    chdir {
      File.write(file, target)
      File.write(file.sub('files', 'pending'), target)
      begin
        Dahistory file
      rescue Dahistory::Pending => e
      end
      Dir.glob("pending/*").size.should == 1
    }
  end

  it "executes :on_raise_pending" do
    file = "files/#{rand 1000}.txt"
    content = rand(1000).to_s
    target = nil
    
    chdir {
      File.write(file, content)
      begin
        Dahistory { |o|
          o.file file
          o.on_raise_pending { target = "done" }
        }
      rescue Dahistory::Pending => e
      end
      target.should == "done"
    }
  end
  
end # === Dahistory: pending file

describe "Dahistory: existing file in ./history" do
  
  before { reset_dirs }

  it "does not raise any error" do
    file = "files/#{rand 10000}.txt"
    target = rand(10000).to_s
    chdir {
      File.write file, target
      File.write file.sub("files", "history"), target
      should.not.raise { Dahistory file }
    }
    
  end
  
end # === Dahistory: existing file in ./history

