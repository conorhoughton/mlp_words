
using Pkg;
using Knet
using Statistics


function predict(w,x)
    x = w[1]*x .+ w[2]
    w[3]*x .+ w[4]
end



function loss(w,x,label)

    y = predict(w,x)
    sum(label.*(-y.+ log.(sum(exp.(y),dims=1))))/size(y,2)

end



lossgradient = grad(loss)

function makeTrain(lr)
    function train(w,data)
        for (x,y) in data
            dw=lossgradient(w,x,y)
            for i in 1:length(w)

                w[i]-=lr*dw[i]
            end
        end
    end
end

function accuracy(w, data)
    ncorrect = ninstance = 0
    for (x, label) in data
        y = predict(w,x)
        ncorrect += sum([c[1] for c in argmax(label,dims=1)]'.==[c[1] for c in argmax(y,dims=1)]')
        ninstance += size(y,2)
    end
    return ncorrect/ninstance
end

function batch(data,batchSize,word_n)
    batches_n=length(data)/batchSize
    dataBatches=Vector{Tuple{Array{Float64},Array{Float64}}}
    for i in 0:batches_n-1
        x=zeros(Int8,(word_n,batchSize))
        y=zeros(Int8,(word_n,batchSize))
        for j in 1:batchSize
            x[data[1][i*batchSize+j] ,j]=1
            y[data[2][i*batchSize+j] ,j]=1
        end
        push!(dataBatches,(x,y))
    end
    dataBatches
end


include("tokenize.jl")
fileName="middlemarch.txt"

word_n=1000::Int64

allWords=get_word_list(fileName,word_n)
data=getData(fileName,allWords)


batchSize=100
dataBatches=batch(data,batchSize,word_n)

middle_n=2


w=map(Array{Float32}, [ 0.1*randn(middle_n,word_n), zeros(middle_n,1), 0.1*randn(word_n,middle_n), zeros(word_n,1) ])

xVector=zeros(Int64,word_n)
yVector=zeros(Int65,word_n)

println(accuracy(w,data_batches))

lr=0.5
train=makeTrain(lr)

println(gpu())

for i=1:10
    train(w, dataBatches)
    println(i," ",accuracy(w,dataBatches))
end

