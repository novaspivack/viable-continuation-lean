import Mathlib
import ViableContinuation.Core.System

/-!
# ViableContinuation.Core.Constraints

**Phase II: Abstract Ontology — Constraint relation and capacity notion.**

Constraints restrict or govern system behavior. "Constraint capacity" (Phase III)
measures how much the system can enforce. Minimal version: constraints as predicates
on states; capacity as order-theoretic comparison.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Core

universe u

variable {S : RecordBearingSystem}

/-- A system has a constraint structure: constraints that can hold or fail at states. -/
class HasConstraints (S : RecordBearingSystem) where
  Constraint : Type u
  satisfied : S.State → Constraint → Prop

/-- A state satisfies a constraint when the constraint holds there. -/
def constraintHolds [HasConstraints S] (s : S.State) (c : @HasConstraints.Constraint S _) : Prop :=
  HasConstraints.satisfied s c

/-- Constraint capacity is a preorder on "amounts" of effective constraint.
    Phase III will add measure-theoretic refinements. For now we introduce the type
    as a placeholder for order-theoretic comparison. -/
structure ConstraintCapacity (S : RecordBearingSystem) [HasConstraints S] where
  /-- The carrier: e.g. a type of capacity levels. -/
  carrier : Type u
  /-- Comparison: less capacity means weaker constraint enforcement. -/
  le : carrier → carrier → Prop

end Core
end ViableContinuation
