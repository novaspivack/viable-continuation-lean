import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Channels
import ViableContinuation.Measures.Correlation
import ViableContinuation.Theorems.Robustness

/-!
# ViableContinuation.Theorems.CorrelatedFailure

**Phase V Ridge 3: Correlated Failure Theorem.**

Strengthens the foothill: common-mode failure defeats the system's ability to rely on
multiplicity as protection. When all channels in a set fail together at some state,
independent correction is not available — correlation damages correction structure.

This is the redundancy pillar of the framework.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Theorems

open ViableContinuation.Core
open ViableContinuation.Measures

universe u

variable (S : RecordBearingSystem) [HasChannels S]

/-- Correlated Failure Theorem (ridge).

    When common-mode failure occurs for chs (all channels in chs fail at some state),
    the system does not have independent correction available for that channel set.
    At the failure state, no channel is working — multiplicity does not protect.

    This upgrades the foothill from a direct contradiction to a structural claim:
    correlation defeats the ability to rely on channel redundancy for correction.
-/
theorem correlated_failure
    (chs : Set (@HasChannels.Channel S _))
    (hWitness : ∃ s : S.State, commonModeFailure chs s) :
    ¬ independentCorrectionAvailable S chs := by
  intro hIndep
  obtain ⟨s, hCM⟩ := hWitness
  obtain ⟨ch, hch, hN⟩ := hIndep s
  exact hN (hCM.2 ch hch)

end Theorems
end ViableContinuation
