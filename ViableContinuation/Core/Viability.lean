import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Transitions

/-!
# ViableContinuation.Core.Viability

**Phase II: Abstract Ontology — Global viability and pathology.**

- `Viable` : predicate on states (or trajectories) indicating whole-system viability
- `Pathology`, `Fragility`, `Collapse` : derived failure notions
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Core

universe u

variable {S : RecordBearingSystem}

/-- A system has a global viability predicate on states. -/
class HasViability (S : RecordBearingSystem) where
  Viable : S.State → Prop

/-- Viable continuation at a state: the system is viable there. -/
def viableAt (S : RecordBearingSystem) [HasViability S] (s : S.State) : Prop :=
  HasViability.Viable s

namespace HasViability

variable (S : RecordBearingSystem) [HasViability S]

/-- Pathology: a state (or situation) fails to support viable continuation.
    Defined as the negation of viability for minimality. -/
def Pathology (s : S.State) : Prop :=
  ¬ HasViability.Viable s

/-- Fragility: susceptibility to pathology under perturbation.
    Minimal version: a state is fragile if there exists a transition to a pathological state. -/
def Fragility [HasTransitions S] (s : S.State) : Prop :=
  ∃ s', HasTransitions.transition s s' ∧ HasViability.Pathology S s'

/-- Collapse: a state is collapsed if it is pathological and represents
    a terminal failure (e.g. no recovery). Refined in measures. -/
def Collapse (s : S.State) : Prop :=
  HasViability.Pathology S s

end HasViability

end Core
end ViableContinuation
