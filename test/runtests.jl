using SafeTestsets

files = readdir()
filter!(f -> f ≠ "runtests.jl" && contains(f, ".jl"), files)
include.(files)
