import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Constraints
import ViableContinuation.Core.Viability
import ViableContinuation.Measures.ConstraintCapacity
import ViableContinuation.Theorems.Robustness
import ViableContinuation.Theorems.ConstraintDeficitBlocksViableContinuation

/-!
# ViableContinuation.Theorems.ConstraintDeficit

**Phase V Ridge 4: Constraint Deficit Theorem.**

Strengthens the foothill with a capacity-theoretic notion: when capacity deficit exists
somewhere, the system cannot rely on sufficient capacity to support viability everywhere.
Deficit defeats capacity-guided robustness — the capacity pillar of the framework.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Theorems

open ViableContinuation.Core
open ViableContinuation.Measures

universe u

variable (S : RecordBearingSystem) [HasConstraints S] [HasConstraintCapacity S]

/-- Constraint Deficit Theorem (ridge).

    When there exists a state with capacity deficit, the system does not have
    capacity support for viability. Capacity deficit defeats the ability to
    sustain viability-preserving continuation through sufficient capacity everywhere.

    Parallel to the other ridge theorems: bad capacity breaks viability support.
-/
theorem constraint_deficit
    (hWitness : ∃ s : S.State, capacityDeficit s) :
    ¬ capacitySupportsViability S := by
  intro hSupp
  obtain ⟨s, hDef⟩ := hWitness
  exact hDef (hSupp s)

variable [HasViability S]

/-- Deficit plus viability-capacity link blocks robust viable continuation.
    Composes the ridge theorem with the viability link: when viability implies
    capacity sufficiency and deficit exists, robust viable continuation fails. -/
theorem constraint_deficit_blocks_viable_continuation_ridge
    (hLink : ∀ s : S.State, HasViability.Viable s → capacitySufficient s)
    (hWitness : ∃ s : S.State, capacityDeficit s) :
    ¬ capacitySupportsViability S ∧ ¬ robustViableContinuation S := by
  constructor
  · exact constraint_deficit S hWitness
  · exact constraint_deficit_blocks_viable_continuation S hLink hWitness

end Theorems
end ViableContinuation
