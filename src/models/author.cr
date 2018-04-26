require "granite_orm/adapter/mysql"

class Author < Granite::ORM::Base
  adapter mysql
  table_name "author"
  field name : String
  field nationality : String
  timestamps
end
