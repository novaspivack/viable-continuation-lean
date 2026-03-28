import Lake
open Lake DSL

package «viable-continuation-lean» where
  -- Viable Continuation Under Constraint: general theory of stability, pathology, collapse.

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.29.0-rc6"

@[default_target]
lean_lib «ViableContinuation» where
  globs := #[.submodules `ViableContinuation]
