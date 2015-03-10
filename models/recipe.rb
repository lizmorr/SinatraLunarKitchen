require "pg"

def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')
    yield(connection)
  ensure
    connection.close
  end
end

class Recipe
  def initialize(id,name,instructions,description)
    @id = id
    @name = name
    @instructions = instructions
    @description = description
    @ingredients = Ingredient.get(@id)
  end

  def id
    @id
  end

  def name
    @name
  end

  def instructions
    @instructions
  end

  def description
    @description
  end

  def ingredients
    @ingredients
  end

  def self.all
    all_recipes =[]
    recipes = db_connection { |conn| conn.exec 'SELECT * FROM recipes;' }
    recipes.each do |recipe|
      all_recipes << Recipe.new(recipe["id"], recipe["name"],
                                recipe["instructions"], recipe["description"])
    end
    all_recipes
  end

  def self.find(recipe_id)
    recipe_db = db_connection { |conn| conn.exec "SELECT * FROM recipes
      WHERE recipes.id=#{recipe_id};"}.to_a
    if recipe_db.length > 0
      recipe = Recipe.new(recipe_db[0]["id"],recipe_db[0]["name"],
        recipe_db[0]["instructions"], recipe_db[0]["description"])
    else
      recipe = Recipe.new(recipe_id,nil,"This recipe doesn't have any instructions.",
                          "This recipe doesn't have a description.")
    recipe
    end
  end

end
