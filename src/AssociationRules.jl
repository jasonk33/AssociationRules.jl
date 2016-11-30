module AssociationRules

export apriori, dataset, sanitize_input!

include("./src/arules.jl")
include("./src/utils.jl")

init_arules()

end # module
