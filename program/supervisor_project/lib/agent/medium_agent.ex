defmodule Inventory do
  use Agent

  # Start the Agent with an empty map
  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  # Add a new product with an initial stock level
  def add_product(product, initial_stock) do
    Agent.update(__MODULE__, fn inventory ->
      Map.put(inventory, product, initial_stock)
    end)
  end

  # Update the stock level of a product
  def update_stock(product, quantity) do
    Agent.update(__MODULE__, fn inventory ->
      Map.update(inventory, product, quantity, &(&1 + quantity))
    end)
  end

  # Get the current stock level of a product
  def get_stock(product) do
    Agent.get(__MODULE__, fn inventory ->
      Map.get(inventory, product, 0)
    end)
  end

  # List all products and their stock levels
  def list_products do
    Agent.get(__MODULE__, fn inventory -> inventory end)
  end
end

# Simulate a business scenario
defmodule BusinessScenario do
  def run do
    # Start the Inventory Agent
    {:ok, _} = Inventory.start_link(nil)

    # Add products to the inventory
    Inventory.add_product("Product A", 100)
    Inventory.add_product("Product B", 200)
    Inventory.add_product("Product C", 300)

    # Update stock levels
    Inventory.update_stock("Product A", 50)
    Inventory.update_stock("Product B", -30)
    Inventory.update_stock("Product C", 20)

    # Get current stock levels
    IO.puts("Stock level of Product A: #{Inventory.get_stock("Product A")}")
    IO.puts("Stock level of Product B: #{Inventory.get_stock("Product B")}")
    IO.puts("Stock level of Product C: #{Inventory.get_stock("Product C")}")

    # List all products and their stock levels
    IO.inspect(Inventory.list_products())
  end
end

# BusinessScenario.run()
