# wrapper for arules.R

using RCall
using DataFrames


function init_arules()
    R"""
    test1p1 <- 1 + 1
    """
    if 2 == (@rget test1p1)
        R"""
        rm(test1p1)                     # remove to avoid memory usage
        """
    else
        stop("You must have R installed in order to use this package")
    end

    R"""
    if (\"arules\" %in% installed.packages() == FALSE) {
        install.packages(\"arules\", dependencies = TRUE, repos = \"http://cran.r-project.org\")
    }
    library(arules)

    all_factors <- function(dat) {
        p <- ncol(dat)
        out <- dat
        for (j in 1:p) {
            out[, j] <- factor(dat[, j])
        }
        return(out)
    }


    character_columns <- function(dat) {
        p <- ncol(dat)
        for (j in 1:p) {
            if (is.factor(dat[, j])) {
                dat[, j] <- as.character(dat[, j])
            }

        }
        return(dat)
    }
    """
    return nothing
end

# init_arules()

"""
    sanitize_input!(dat::DataFrame)
This is a simple function that assures we don't have strings
with a " => " as part of them. This is something R outputs
when it creates rules, and we'll uses it's presence to split
rules generated by R into left-hand side (lhs) and rhs.
"""
function sanitize_input!(dat)
    n, p = size(dat)
    for j = 1:p
        if eltype(dat[:, j]) <: Number
            continue
        end
        for i = 1:n
            dat[i, j] = replace(dat[i, j], " => ", " ")
        end
    end
end


function split_rule!(dat)
    n = size(dat, 1)
    dat[:lhs] = Array{String,1}(n)
    dat[:rhs] = Array{String,1}(n)
    for i = 1:n
        dat[i, :lhs], dat[i, :rhs] = split(dat[i, :rules], " => ")
    end
end

"""
    apriori(dat::DataFrame, supp::Float64, conf::Float64)
The apriori function implements the a-priori algorithm for
association rule mining. It returns a DataFrame with rules
with minimum support greater than or equal to `supp` and
confidence greater than or equal to `conf`.

function apriori(dat::DataFrame, supp = 0.2, conf = 0.01)
    @rput dat

    rcode = "
    dat <- all_factors(dat)
    transacts <- as(dat, \"transactions\")

    rules1 <- apriori(transacts,
                      parameter = list(supp = $supp,
                                       conf = $conf,
                                       target = \"rules\"),
                      control = list(verbose = FALSE))

    rules1 <- if (length(rules1) == 0) data.frame() else rules1
    rules1 <- character_columns(as(rules1, \"data.frame\"))
    "
    reval(rcode);
    rules_df = @rget rules1;             # get dataframe from R

    R"""
    rm(dat, transacts, rules1)           # clean up R environment
    """
    split_rule!(rules_df);
    rules_df = rules_df[:, [:lhs, :rhs, :support, :confidence, :lift]]
    rules_df
end

# d = readtable("./data/adult.csv")
# sanitize_input!(d)
# a = apriori(d);
