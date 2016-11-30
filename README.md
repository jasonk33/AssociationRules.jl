# AssociationRules
[![Build Status](https://travis-ci.org/bcbi/AssociationRules.jl.svg?branch=master)](https://travis-ci.org/bcbi/AssociationRules.jl)
[![codecov](https://codecov.io/gh/bcbi/AssociationRules.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/bcbi/AssociationRules.jl)

## Dependencies
This package requires a working installation of [R]("http://r-project.org").


## Description
This package implements algorithms for association rule mining by wrapping the _arules_ package in R. In particular, we have currently implemented the _Apriori_ algorithm (Agrawal & Srikant, 1994). This can be used for association rule mining (e.g., "market basket" analysis).



## Initial Setup
```{Julia}
Pkg.clone("https://github.com/bcbi/AssociationRules.jl.git")
```

## Examples
Several examples below illustrate the use and features of the `apiori()` function and the `spade()` function.

### Ex. 1 _Apriori_ Algorithm:
Here we are generating association rules using the `apriori()` function.
```{Julia}
using AssociationRules
using StatsBase                        # for sample() function

# simulate transactions
groceries = ["milk", "bread", "eggs", "apples", "oranges", "beer"]
transactions = [sample(groceries, 4, replace = false) for x in 1:1000]
transactions_df = DataFrame(transactions)

# minimum support of 0.2, minimum confidence of 0.8
rules = apriori(transactions_df, 0.2, 0.8)
```
