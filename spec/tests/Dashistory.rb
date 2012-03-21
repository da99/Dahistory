
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

