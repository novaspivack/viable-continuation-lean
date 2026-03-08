import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Constraints
import ViableContinuation.Core.Viability
import ViableContinuation.Measures.ConstraintCapacity
import ViableContinuation.Theorems.Robustness

/-!
# ViableContinuation.Theorems.ConstraintDeficitBlocksViableContinuation

**Phase IV Foothill 4: Constraint deficit blocks viable continuation theorem.**

Under the viability-capacity link (viability implies capacity sufficiency), the existence
of a capacity-deficit state precludes robust viable continuation. Local witness → system-level
impossibility, parallel to foothill 1.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Theorems

open ViableContinuation.Core
open ViableContinuation.Measures

universe u

variable (S : RecordBearingSystem) [HasConstraints S] [HasConstraintCapacity S] [HasViability S]

/-- Constraint deficit blocks viable continuation theorem.

    When (1) viability implies capacity sufficiency everywhere, and (2) there exists
    a state with capacity deficit, then the system does not have robust viable
    continuation (some state is pathological).
-/
theorem constraint_deficit_blocks_viable_continuation
    (hLink : ∀ s : S.State, HasViability.Viable s → capacitySufficient s)
    (hWitness : ∃ s : S.State, capacityDeficit s) :
    ¬ robustViableContinuation S := by
  intro hRobust
  obtain ⟨s, hDef⟩ := hWitness
  have hVia := hRobust s
  have hSuff := hLink s hVia
  exact hDef hSuff

end Theorems
end ViableContinuation
