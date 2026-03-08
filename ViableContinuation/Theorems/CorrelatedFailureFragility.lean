import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Channels
import ViableContinuation.Measures.Correlation

/-!
# ViableContinuation.Theorems.CorrelatedFailureFragility

**Phase IV Foothill 5: Correlated failure fragility theorem.**

Common-mode failure defeats robust protection. Uses a theorem-specific notion
(robustAgainstCommonModeFailure) rather than an overgeneral Fragility predicate.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Theorems

open ViableContinuation.Core
open ViableContinuation.Measures

universe u

variable (S : RecordBearingSystem) [HasChannels S]

/-- Robust against common-mode failure for channel set chs: at no state do all
    channels in chs fail together. When this fails, a common mode has failed.
    Theorem-specific notion; keeps the theorem crisp. -/
def robustAgainstCommonModeFailure (chs : Set (@HasChannels.Channel S _)) : Prop :=
  ∀ s : S.State, ¬ commonModeFailure chs s

/-- Correlated failure fragility theorem.

    When common-mode failure occurs for chs at some state, the system is not
    robust against common-mode failure for that channel set. Local witness →
    system-level robustness failure.
-/
theorem correlated_failure_fragility
    (chs : Set (@HasChannels.Channel S _))
    (hWitness : ∃ s : S.State, commonModeFailure chs s) :
    ¬ robustAgainstCommonModeFailure S chs := by
  intro hRobust
  obtain ⟨s, hCM⟩ := hWitness
  exact hRobust s hCM

end Theorems
end ViableContinuation
