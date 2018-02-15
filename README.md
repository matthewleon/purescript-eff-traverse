# purescript-eff-traverse

Efficiently traverse any law-abiding `Traversable` in `Eff`.

Using `Traversable` methods directly with `Eff` results in accumulation of a thunk, potentially causing stack overflow upon evaluation. This library sidesteps the problem.

Note: this is unsafe, and will probably soon be replaced with a smarter approach to the problem.
