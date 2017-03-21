# arules_testing.jl

using RCall
using DataFrames
using StatsBase                        # for sample() function


include("arules.jl")
include("utils.jl")

init_arules()                       # this is called automatically by `using AssociationRules`




# simulate transactions
groceries = ["milk", "bread", "eggs", "apples", "oranges", "beer"]
transacts = [sample(groceries, 4, replace = false) for x in 1:1000]
transacts_df = DataFrame(transactions(transacts))

# minimum support of 0.2, minimum confidence of 0.8
rules = apriori(transacts_df, 0.2, 0.8)





adult = dataset("adult")            # example dataset included in package
sanitize_input!(adult)              # remove excluded character patterns (e.g., " => ")

# minimum support of 0.1, minimum confidence of 0.8
rules = apriori(adult, 0.1, 0.8)
