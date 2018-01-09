"""
    ItemT

Is a new type introduced by our package for control 
the Item Object. This object is MUTABLE and has four
arguments: 

    length::Float64  is the length of the item

    height::Float64  is the height of the item

    posX::Float64  position X of the item in container

    posY::Float64  position X of the item in container

    ItemT(lenght,height,posX,posY)

# Examples
```julia-repl
julia> ItemT(1.0, 2.0, 0.0, 0.0)
```
"""
mutable struct ItemT <: Number
    length::Float64 # is the length of the item
    height::Float64 # is the height of the item
    posX::Float64 # position X of the item in container
    posY::Float64 # position X of the item in container
end 

abstract type ContainerType end
"""
    ContainerT

Is a new type introduced by our package for control 
the Container Object. This object is MUTABLE and has three
arguments: 

    length::Float64  is the length of the container

    height::Float64  is the height of the container

    content::Array{ItemT} is an array of items

    ContainerT(lenght,height,content)

# Examples
```julia-repl
julia> ContainerT(1.0, 2.0, 0.0, [ItemT(1.0, 2.0, 0.0, 0.0),ItemT(2.0, 1.5, 1.0, 1.0)])
```
"""
mutable struct ContainerT <: ContainerType
    length::Float64
    height::Float64
    content::Array{ItemT}
end

importall Base.Operators
function Base.copy(A::Any)
    if typeof(A)==ContainerT
        return ContainerT((A.length),(A.height),(A.content))
    end
    if typeof(A)==Array{ContainerT,1}
        m=length(A)
        B=Array{ContainerT}(m)
        for i=1:m 
                B[i]=ContainerT((A[i].length),(A[i].height),(A[i].content))
        end
        return B
    end        
end

export ContainerType,ContainerT,ItemT,copy