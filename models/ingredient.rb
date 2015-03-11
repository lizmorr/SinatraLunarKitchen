require "pg"

def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')
    yield(connection)
  ensure
    connection.close
  end
end

class Ingredient
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def self.get(id)
    all_ingredients = []
    sql_statement = "SELECT name FROM ingredients WHERE recipe_id = #{id};"
    ingredient_db = db_connection { |conn| conn.exec(sql_statement) }
    ingredient_db.each do |ingredient|
      all_ingredients << Ingredient.new(ingredient["name"])
    end
    all_ingredients
  end

end
