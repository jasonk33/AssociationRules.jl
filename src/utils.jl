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
