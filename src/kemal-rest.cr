require "./kemal-rest/*"
require "./models/*"

require "kemal"

before_all do |env|
  env.response.content_type = "application/json"
end

get "/" do |env|
  {datail: "Kemal RESTful CRUD", author: "Ocki Bagus Pratama", email: "ocki.bagus.p@gmail.com"}.to_json
end

get "/author" do |env|
  authors = Author.all

  if authors.empty?
    {datail: "no data"}.to_json
  else
    authors.to_json
  end
end

post "/author" do |env|
  if env.params.json.has_key?("name") && env.params.json.has_key?("nationality")
    author = Author.new
    author.name = env.params.json["name"].to_s
    author.nationality = env.params.json["nationality"].to_s
    author.save
    env.response.status_code = 201
    author.to_json
  else
    # TODO response status 500
    {datail: "not ok"}.to_json
  end
end

get "/author/:id" do |env|
  author = Author.find env.params.url["id"]

  if author
    author.to_json
  else
    env.response.status_code = 404
  end
end

put "/author/:id" do |env|
  author = Author.find env.params.url["id"]

  if author
    if env.params.json.has_key?("name")
      author.name = env.params.json["name"]?.to_s
    end

    if env.params.json.has_key?("nationality")
      author.nationality = env.params.json["nationality"]?.to_s
    end
    author.save
    author.to_json
  else
    env.response.status_code = 404
  end
end

error 400 do |env|
  env.response.content_type = "application/json"
  {status: "error", message: "bad_request"}.to_json
end

error 404 do |env|
  env.response.content_type = "application/json"
  {status: "error", message: "not_found"}.to_json
end

Kemal.run
