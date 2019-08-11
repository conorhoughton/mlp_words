
include("tokenize.jl")

fileName="middlemarch.txt"

word_n=1000::Int64

allWords=get_word_list(fileName,word_n)

data=getData(fileName,allWords)

for (x,y) in data
    println(allWords[x]," ",allWords[y])
end
