vids = ["mp4","m4a","m4v", "f4v", "f4a", "m4b", "m4r", "f4b", "mov","3gp","3gp2","3g2","3gpp","3gpp2","ogg","oga","ogv","ogx","wmv","wma","asf","flv","avi","wav"].map{|e| ".#{e}"}
command = "ls -al " + "/Users/kings/dev/projects/videom/public/uploads"
io = IO::Memory.new
Process.run(command, shell: true, output: io)
output = io.to_s
videos = output.split("\n").map{|entry| entry.split(" ").reverse.first }.select{|v|
  begin
    vids.includes?(File.extname(v))
  rescue
    false
  end
}
