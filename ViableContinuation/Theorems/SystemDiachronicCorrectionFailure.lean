import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Viability
import ViableContinuation.Measures.TraceCapacity
import ViableContinuation.Theorems.Robustness

/-!
# ViableContinuation.Theorems.SystemDiachronicCorrectionFailure

**Phase IV Foothill 1: System diachronic correction failure theorem.**

Move from state-level trace-floor failure to system-level correction impossibility.
Insufficient trace floor somewhere blocks robust diachronic correction for the system.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Theorems

open ViableContinuation.Core
open ViableContinuation.Measures

universe u v

variable (S : RecordBearingSystem) [HasViability S]

/-- System-level diachronic correction failure theorem.

    If there exists a state without trace floor, then the system does not have
    robust diachronic correction. This lifts the state-level measure lemma
    to a system-level structural theorem.
-/
theorem system_diachronic_correction_failure :
    (∃ s : S.State, ¬ hasTraceFloor s) → ¬ robustDiachronicCorrection S := by
  intro ⟨s, hNoFloor⟩ hRobust
  have hFail := not_hasTraceFloor_implies_diachronic_correction_fails s hNoFloor
  exact hRobust s hFail

end Theorems
end ViableContinuation
