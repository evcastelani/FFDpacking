module FFDpacking 

include("objects.jl")

export load_data,ffdpacking,config_container,draw_container,run_pack

#reading input data
"""
    load_data(filecont::String,fileitem::String)

Load data for use first fit decrease function (ffd).
This function return two vector. The first one is 
a vector of item type (ItemT) and the second is a 
vector of container type (ContainerT).

# Examples
```julia-repl
julia> output=load_data("container.txt","item.txt")
       list_cont=output[2]
       list_item=output[1]
```
"""
function load_data(filecont::String,fileitem::String)
    item_txt=readdlm(fileitem)
    n=length(item_txt[:,1])
    v_item=Array{ItemT}(n)
    for i=1:n
        v_item[i]=ItemT(item_txt[i,1],item_txt[i,2],0,0)
    end
    container_txt=readdlm(filecont)
    m=length(container_txt[:,2])
    v_container=Array{ContainerT}(m)
    for i=1:m
        v_container[i]=ContainerT(container_txt[i,1],container_txt[i,2],[])
    end
    return v_item,v_container    
end

#main function for packing
"""
    ffd(list_container,list_item)

Allocate the list_item in containers type find in list_container.

# Examples

```julia-repl
julia> run_pack("container.txt","item.txt")
```
"""
function ffdpacking(list_container,list_item)
    #creating an array of container
    v_container=Array{ContainerT}(50)
    #selecting the type of container
    container=copy(list_container[2])
    #setting the first element of v_container
    for i=1:10
    v_container[i]=copy(container)
    end
    ncontainer=1
    #setting auxiliary variables
    s_height=0.0
    s_length=0.0
    size_list=length(list_item)
    updated_list=copy(list_item)
    strip=updated_list[1].height
    s_height=updated_list[1].height
    #main loop for all elements
    while !isempty(updated_list)
        i=1
        removed_item=[]
        if s_height<=v_container[ncontainer].height
            while s_length<=v_container[ncontainer].length && i<=size_list
                if s_length + updated_list[i].length<=v_container[ncontainer].length
                    s_length+=updated_list[i].length
                    removed_item=push!(removed_item,i)
                    v_container[ncontainer].content=[v_container[ncontainer].content;updated_list[i]]
                end
                i+=1
            end          
            deleteat!(updated_list,removed_item)
            size_list=length(updated_list)
            #display(updated_list)
            if isempty(updated_list)
                break
            end    
            s_height+=updated_list[1].height
            s_length=0.0
        else
            println("Container $ncontainer :")
            display(v_container[ncontainer])
            println("New container was created ...")
            s_height=updated_list[1].height
            s_length=0.0
            ncontainer+=1
            size_list=length(updated_list)
           
        end
        
    end
    println("Container $ncontainer :")
    display(v_container[ncontainer])
    println("Configuring containers ... ")
    for i=1:ncontainer
        v_container[i]=config_container(v_container[i])
        draw_container(v_container[i],i);
    end
    display(v_container[1:ncontainer])
end

#configuring container assuming that the allocation was done (auxiliary function)
"""
    config_container(container)

Given a contaneir with a list of items in its content property, this
function generates the position of items in that container. More specifically,
this function changes posX and posY in each item of the list in content.

"""

function config_container(container)
    s_length=0.0
    s_height=0.0
    strip=container.content[1].height
    for item in container.content
        if (s_length+item.length)>container.length
            s_length=0.0
            s_height+=strip
            strip=item.height
        end
        item.posX=s_length
        item.posY=s_height
        s_length=s_length+item.length
    end
    return container
end

#sort the list of items (auxiliary function)
"""
    sortitems(list_item)

Basic function for ordering list item.

"""

function sortitems(list_item)
    n=length(list_item)
    for i=1:n
        for j=i+1:n
            if list_item[i].height<list_item[j].height
                swap=list_item[j]
                list_item[j]=list_item[i]
                list_item[i]=swap
            end
        end
    end
    return list_item
end

#packages for drawing solutions
using PyPlot
using PyCall
@pyimport matplotlib.patches as patch
#draw the configuration of one container (auxiliary function)
function draw_container(container,nc)
    cfig = figure();
    ax = cfig[:add_subplot](1,1,1);
    ax[:set_aspect]("equal");
    ax[:set_xlim]([0,container.length]);
    ax[:set_ylim]([0,container.height]);
    for item in container.content
        c = patch.Rectangle([item.posX,item.posY],item.length,item.height,facecolor="red");
        ax[:add_patch](c);
    end
    #ax[:add_artist](c)
    cfig[:savefig]("container$nc.png");
end

#function for testing the main program run_pack
#example run_pack("container.txt","item.txt")
function run_pack(SContainer::String,SItem::String)
    output=load_data(SContainer,SItem)
    list_cont=output[2] #The list of containers
    list_item=output[1] #The list of items
    list_item=sortitems(list_item)
    ffdpacking(list_cont,list_item)
end 

end