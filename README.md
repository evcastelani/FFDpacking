# FFDpacking
It is a primary package about using First Fit Decreasing heuristic for packing problem. 

If you want to use this algorithm you need the following:

- Julia installed
- PyPlot package (`Pkg.add("PyPlot")`)
- PyCall package (`Pkg.add("PyCall"`)

If this conditions are satisfied you can now setup the method in global scope. The main algorithm is Julia module. So, let us suppose that *object.jl* and *FFDpacking.jl* are in your computer in a folder  *Document/Pack*. You can setup this folder for Julia searching. In this casa, in Julia REPL just type 

`push!(LOAD_PATH, ".../Document/Pack")`

Now it is necessary load the algorithm, that is, type `using FFDpacking`.

In order to test if everything is fine, find the files *containers.txt* and *item.txt* and run

`run_pack("container.txt","item.txt" )`

Change the files container.txt and  item.txt as you need. 


