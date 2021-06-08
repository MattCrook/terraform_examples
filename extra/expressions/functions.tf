# zipmap constructs a map from a list of keys and a corresponding list of values
# zipmap(keyslist, valueslist)
# Both keyslist and valueslist must be of the same length. keyslist must be a list of strings, while valueslist can be a list of any type.
node_pools      = zipmap(local.node_pool_names, tolist(toset(var.node_pools)))

# merge takes an arbitrary number of maps or objects, and returns a single map or object that contains a merged set of elements from all arguments.
# If more than one given map or object defines the same key or attribute, then the one that is later in the argument sequence takes precedence.
# If the argument types do not match, the resulting type will be an object matching the type structure of the attributes after the merging rules have been applied.

// > merge({a="b", c="d"}, {e="f", c="z"})
// {
//   "a" = "b"
//   "c" = "z"
//   "e" = "f"
// }

node_pools_oauth_scopes = merge(
    { default-node-pool = [] },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : []]
    ),
    var.node_pools_oauth_scopes
)


# lookup(map, key, default) retrieves the value of a single element from a map, given its key.
# If the given key does not exist, the given default value is returned instead
size = "${lookup(var.storage_sizes, var.plans["5USD"])}"


# coalesce takes any number of arguments and returns the first one that isn't null or an empty string.
# All of the arguments must be of the same type. Terraform will try to convert mismatched arguments to the most general of the types that all arguments can convert to, 
# or return an error if the types are incompatible.
> coalesce("a", "b")
a
> coalesce("", "b")
b
> coalesce(1,2)
1
