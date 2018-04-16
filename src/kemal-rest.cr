require "./kemal-rest/*"

require "db"
require "mysql"
require "kemal"

db = DB.open "mysql://ockifals:admin123@localhost:3306/kemal-rest"

before_all do |env|
  env.response.content_type = "application/json"
end

get "/" do |env|
  {datail: "Kemal RESTful CRUD", author: "Ocki Bagus Pratama", email: "ocki.bagus.p@gmail.com"}.to_json
end

get "/author" do |env|
  results = [] of {id: Int32, name: String, nationality: String}

  fs = db.query_all "SELECT * FROM `author`", as:{Int32, String, String}

  fs.each do |author|
    results << {id: author[0], name: author[1], nationality: author[2]}
  end

  if results.empty?
    {datail: "no data"}.to_json
  else
    results.to_json
  end
end

post "/author" do |env|
  if env.params.json.has_key?("name") && env.params.json.has_key?("nationality")
    db.exec "INSERT INTO `author` (name, nationality) values (?, ?)", env.params.json["name"], env.params.json["nationality"]
    {datail: "ok"}.to_json
  else
    # TODO response status 500
    {datail: "not ok"}.to_json
  end
end

get "/author/:id" do |env|
  author_id = env.params.url["id"]
  author = db.query_one? "SELECT * FROM `author` WHERE `id` = ?", author_id, as:{Int32, String, String}

  if author
    {id: author[0], name: author[1]}.to_json
  else
    # TODO response status 404
    {detail: "Not Found"}.to_json
  end
end

put "/author/:id" do |env|
  if env.params.json.has_key?("name") || env.params.json.has_key?("nationality")
    db.exec "UPDATE `author` SET `name`=? WHERE `id`=?", env.params.json["name"], env.params.url["id"]
    {datail: "ok"}.to_json
  else
    # TODO response status 500
    {datail: "no action"}.to_json
  end
end

Kemal.run
db.close
