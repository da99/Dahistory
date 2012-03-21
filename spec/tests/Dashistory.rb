
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

