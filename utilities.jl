

function discount(freq::Float64)
    min((sqrt(freq/0.001)+1.0)*0.001/freq,1.0)
    #1/freq
    #1.0
end


mutable struct Proximity_word
    word::String
    frequency::Float64
    proximity::Vector{Float64}
    word_i::Int64
end

mutable struct Each_word
    word::String
    frequency::Float64
end

mutable struct All_words
    word_list::Vector{String}
    word_list_dict::Dict{String,Int64}
    target_words::Vector{Proximity_word}
    target_word_dict::Dict{String,Int64}
end


function pretty_print_matrix(matrix::Array{Float64})
    this_size=size(matrix)
    for j in 1:this_size[2]
        for i in 1:this_size[1]
            print(round(matrix[i,j],5))
            print(" ")
        end
        print("\n")
    end
    println("\n")
end


struct Eigen
    eigen_val::Float64
    eigen_vec::Vector{Float64}
end

function save_eigens(eigens::Vector{Eigen},all_words,filename::String)
    f=open("./"*filename,"w")
    for w in all_words.target_words
        word=w.word
        write(f,"$word ")
    end
    write(f,"\n\n")
    for e in eigens
        val=e.eigen_val
        write(f,"$val")
        write(f,"\n")
        for x in e.eigen_vec
            write(f,"$x ")
        end
        write(f,"\n\n")
    end
    close(f)
end
    

function load_eigens(filename::String,line_n::Int64)
    f=open("./"*filename)

    readline(f)
    words=split(readline(f)," ")

    while words[end]==""
        pop!(words)
    end

    if line_n<0
        word_n=length(words)
    else
        word_n=line_n
    end

    eigens=Vector{Eigen}()
    
    for i in 1:word_n
        readline(f)
        e=parse(Float64,readline(f))
        vec=parse.(split(readline(f)," "))
        while vec[end]==nothing
            pop!(vec)
        end
        
        push!(eigens,Eigen(e,vec)) 
    end
    
    
    close(f)

    (words,eigens)

end
