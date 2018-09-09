defmodule Santa do

  def worker(sec) do
    receive do after :rand.uniform(1000) -> :ok end
    send sec,self()
    gate = receive do
      x -> x
    end
    send gate, {:went, self()}
    worker(sec)
  end
  
  def santa() do
    IO.puts("in santa")
    group = receive do
      group -> group
    end
    IO.inspect(group)
    
    for g <- group do
      send g, self()
    end
    for _g <- group do
      receive do
        {:went, _g} -> IO.puts("went")
      end
    end
    santa()
  end
  
  def secretary(species, santa, n) do
    secretary_loop(n, [], species, santa, n)
  end

  def secretary_loop(0, group, species, santa, n) do
    IO.puts("send to santa")
    send santa, group
    secretary(species,santa,n)
  end
  
  def secretary_loop(count, group, species, santa, n) do
    group = receive do
      pid -> [pid | group]
    end
    secretary_loop(count-1,group,species,santa,n)
  end
  
  def start() do
    santa = spawn(fn() -> santa() end)
    sec1 = spawn(fn() -> secretary(:reindeer, santa, 9) end)
    for i <- 0..8 do
      spawn(fn() -> worker(sec1) end)
    end
  end
end

# Next steps:
# erlang OTP
# genserver actor model
# supervisor tree

# conventions over configuration

# Author of Elixir in Action wrote ex actor
# ex actor: writing with macros in elixir

# supervisor/workers

# Phoenix : cowboy (web server)
# come on in - authentication for web
# sweetie http a lot faster (http push)

# Dave Thomas book parallel map
