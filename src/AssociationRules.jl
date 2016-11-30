module AssociationRules

using RCall
using DataFrames

export apriori, dataset, sanitize_input!

include("arules.jl")
include("utils.jl")

init_arules()

end # module
