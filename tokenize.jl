
include("utilities.jl")

    
mutable struct Each_word
    word::String
    frequency::Float64
end


function stripWord(word::String)
    replace(lowercase(word),r"\?|,|:|;|!|\.|\"|\"|-|\(|\)|\_|\]|\[|\'|\*"=>"")
end


function get_word_list(file_name::String,word_n::Int64)


    function calculate_frequencies()
        total=0::Int64
        word_list=Each_word[]        
        open(file_name) do f
            while !eof(f)
                line=readline(f)
                for word in split(line,r" |-")

                    word=stripWord(String(word))

                    if word!=""
                        index=findfirst(x->x.word==word,word_list)
                        if index==nothing
                            push!(word_list,Each_word(word,1))
                        else
                            word_list[index].frequency+=1
                            total+=1
                        end
                    end
                end
            end
        end

        for word in word_list
            word.frequency/=total
        end
      
        word_list
 
    end
    
    word_list=calculate_frequencies()

    sort!(word_list, by= x->x.frequency,rev=true)

    word_list=[w.word for w in word_list[1:word_n]]
        
end

function getData(file_name::String,wordList::Vector{String})

    data=Vector{Tuple{Int64,Int64}}()
    
    oldWord=""::String

    open(file_name) do f
        while !eof(f)
            line=readline(f)
            for word in split(line,r" |-")
                word=String(word)
                if oldWord==stripWord(oldWord)
                    x=findfirst(x->x==oldWord,wordList)
                    if x!=nothing
                        y=findfirst(x->x==stripWord(word),wordList)
                        if y!=nothing
                            push!(data,(x,y))
                        end
                    end
                end
                oldWord=word
            end
        end
    end

    data

end
