

using Knet
using Statistics

include("utilities.jl")

function predict(w,x)
    x = w[1]*x .+ w[2]
    w[3]*x .+ w[4]
end



function log_loss(w,x,label)

    y = predict(w,x)
    sum(label.*(-y.+ log.(sum(exp.(y),dims=1))))/size(y,2)

end


function square_loss(w,x,label)

    y = predict(w,x)
    sum((y-label).*(y-label))/size(y,2)

end

function loss(w,x,label)
#    square_loss(w,x,label)
    log_loss(w,x,label)
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

function batch(data,batchSize,word_n,aType)
    batches_n=floor(Int,length(data)/batchSize)
    dataBatches=aType{Tuple{aType,aType},1}()
    for i in 0:batches_n-1
        x=aType(zeros(Float64,(word_n,batchSize)))
        y=aType(zeros(Float64,(word_n,batchSize)))
        for j in 1:batchSize
            x[data[i*batchSize+j][1] ,j]=1.0
            y[data[i*batchSize+j][2] ,j]=1.0
        end
        push!(dataBatches,(x,y))
    end
    dataBatches
end


include("tokenize.jl")
#fileName="the_snowball_effect.txt"
fileName="middlemarch.txt"
#fileName="all_camp.txt"
#fileName="some_old_million.txt"

word_n=500::Int64

allWords=get_word_list(fileName,word_n)
data=getData(fileName,allWords)


batchSize=100
dataBatches=batch(data,batchSize,word_n)

middle_n=2

aType=Array{Float64}
if gpu()>=0
    aType=KnetArray{Float64}

w=map(aType, [ 0.1*randn(middle_n,word_n), zeros(middle_n,1), 0.1*randn(word_n,middle_n), zeros(word_n,1) ])


lr=0.5
train=makeTrain(lr)



for i=1:2000
    train(w, dataBatches)
#    println(i," ",accuracy(w,dataBatches))
end

for (i,word) in enumerate(allWords)
    print(word)
    printVector(w[1][:,i],"\n")
end
