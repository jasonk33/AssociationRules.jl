# AssociationRules
[![Build Status](https://travis-ci.org/bcbi/AssociationRules.jl.svg?branch=master)](https://travis-ci.org/bcbi/AssociationRules.jl)
[![codecov](https://codecov.io/gh/bcbi/AssociationRules.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/bcbi/AssociationRules.jl)

## Dependencies
This package requires Julia 0.5 (at minimum) and a working installation of [R]("http://r-project.org").


## Description
This package implements algorithms for association rule mining by wrapping the _arules_ package in R. In particular, we have currently implemented the _Apriori_ algorithm (Agrawal & Srikant, 1994). This can be used for association rule mining (e.g., "market basket" analysis).



## Initial Setup
```{Julia}
Pkg.clone("https://github.com/bcbi/AssociationRules.jl.git")
```

## Examples
Several examples below illustrate the use and features of the `apiori()` function. Note a key feature in all examples is that a given transaction (or item set) is a row in a `DataFrame` object. So as of this writing, your data must be structured in this manner in order to use the package.

### Ex. 1 _Apriori_ with Simulated Data:
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

### Ex. 2 _Apriori_ with `Adult` [Data](http://mlr.cs.umass.edu/ml/datasets/Adult)
Note that we are using only subset (≈32k rows) of the `Adult` data in the example below.
```{Julia}
using AssociationRules

dataset("adult")            # example dataset included in package
sanitize_input!(adult)      # remove excluded character patterns (e.g., " => ")

# minimum support of 0.1, minimum confidence of 0.8
rules = apiori(adult, 0.1, 0.8)

```


## In progress
- Re-writing algorithms in pure Julia to eliminate dependencies


## _Caveats_
- This package is under active development. Please notify us of bugs or proposed improvements by submitting an issue or pull request.
