# purescript-eff-traverse

Efficiently traverse any law-abiding `Traversable` in `Eff`.

Using `Traversable` methods directly with `Eff` results in accumulation of a thunk, potentially causing stack overflow upon evaluation. This library sidesteps the problem.
