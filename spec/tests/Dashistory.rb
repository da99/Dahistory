
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

describe "Dahistory: new pending file" do

  before { reset_dirs }
  
  it "copies file to pending dir" do

    file = "files/a.txt"
    target = rand(1000).to_s
    chdir {
      File.write(file, target)
      pending = begin
                  Dahistory "files/a.txt" 
                rescue Dahistory::Pending => e
                  e.message
                end
      File.read(pending).should == target
    }
  end
  
end # === Dahistory: new pending file

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

