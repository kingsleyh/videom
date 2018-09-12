require "kemal"
require "json"

get "/" do |env|
  "woop"
end

post "/api/upload" do |env|
  env.response.headers.add("Access-Control-Allow-Origin", "*")
  HTTP::FormData.parse(env.request) do |upload|
    filename = upload.filename
    if !filename.is_a?(String)
      p "No filename included in upload"
    else
      file_path = ::File.join [Kemal.config.public_folder, "uploads/", filename]
      File.open(file_path, "w") do |f|
        IO.copy(upload.body, f)
      end
      "Upload ok"
    end
  end
end

get "/api/all" do |env|
  env.response.headers.add("Access-Control-Allow-Origin", "*")
  env.response.content_type = "application/json"
  file_path = ::File.join [Kemal.config.public_folder, "uploads/"]
  vids = ["mp4","m4a","m4v", "f4v", "f4a", "m4b", "m4r", "f4b", "mov","3gp","3gp2","3g2","3gpp","3gpp2","ogg","oga","ogv","ogx","wmv","wma","asf","flv","avi","wav"].map{|e| ".#{e}"}
  command = "ls -al " + file_path
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
  {videos: videos}.to_json
end

get "/api/del/:filename" do |env|
  env.response.headers.add("Access-Control-Allow-Origin", "*")
  env.response.content_type = "application/json"
  filename = env.params.url["filename"]
  file_path = ::File.join [Kemal.config.public_folder, "uploads/", filename]
  if File.exists?(file_path)
  command = "rm #{file_path}"
  io = IO::Memory.new
  Process.run(command, shell: true, output: io)
  output = io.to_s
  {message: "deleted file: #{filename}"}.to_json
 else
  {message: "no file found: #{filename}"}.to_json
 end
end



Kemal.run
# curl -F 'filename=@/path/to/hello.txt' http://localhost:3000/upload
