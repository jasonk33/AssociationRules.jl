"""
    dataset(dataset_name::AbstractString)

This is a convenience function whose only purpose is to load example datasets provided with this package.

### Arguments
* `dataset_name`: A string specifying the dataset to be loaded (e.g., "zaki_data", "adult", etc).

The returned value will be a dataframe.
"""
function dataset(dataset_name::AbstractString)
    filename = joinpath(dirname(@__FILE__), "..", "data", "$dataset_name.csv")

    if !isfile(filename)
        error(@sprintf "Unable to locate file %s \n" filename)
    else
        return readtable(filename)
    end
end


function assemble_string_mat(n::Int, p::Int)
    res = Array{String, 2}(n, p)
    empty_row = repeat([""], inner = n, outer = 1)
    for j = 1:p
        res[:, j] = empty_row
    end
    res
end


function transactions(v::Array{String,1}, sep = ",")
    n = length(v)
    num_cols = 0
    for i = 1:n
        transact = convert(Array{String,1}, split(v[i], sep))
        num_cols = (num_cols > length(transact)) ? num_cols : length(transact)
    end

    transact_mat = assemble_string_mat(n, num_cols)

    for i = 1:n
        transact = convert(Array{String,1}, split(v[i], sep))
        last_idx = length(transact)
        transact = map(strip, transact)
        sort!(transact)

        transact_mat[i, 1:last_idx] = transact
    end
    return DataFrame(transact_mat)
end


function transactions(v::Array{Array{String,1},1})
    n = length(v)
    num_cols = 0
    for i = 1:n
        num_cols = (num_cols > length(v[i])) ? num_cols : length(v[i])
    end

    transact_mat = assemble_string_mat(n, num_cols)

    for i = 1:n
        last_idx = length(v[i])
        transact = map(strip, v[i])
        sort!(transact)
        transact_mat[i, 1:last_idx] = transact
    end
    return DataFrame(transact_mat)
end




W = ["this, is, a, transaction", "and this, is, also"]

transactions(W)
