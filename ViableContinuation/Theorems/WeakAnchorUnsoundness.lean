import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Viability
import ViableContinuation.Core.Anchors
import ViableContinuation.Measures.ProxyDetachment
import ViableContinuation.Theorems.Robustness

/-!
# ViableContinuation.Theorems.WeakAnchorUnsoundness

**Phase IV Foothill 2: Weak anchor unsoundness theorem.**

Weak anchoring prevents reliable proxy-based viability discrimination.
Without anchor fidelity, discrimination between viable and nonviable states breaks.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Theorems

open ViableContinuation.Core
open ViableContinuation.Measures

universe u

variable (S : RecordBearingSystem) [HasViability S] [HasAnchors S]

/-- Weak anchor unsoundness theorem.

    If the proxy is weakly anchored, it is not proxy-sound. A weakly anchored
    proxy conflates some viability-distinct states (proxy-indistinguishable pair),
    which directly violates the proxySound condition.
-/
theorem weak_anchor_unsoundness
    (p : @HasAnchors.Proxy S _ _) (h : weaklyAnchored p) :
    ¬ proxySound S p := by
  intro hSound
  obtain ⟨s, s', ⟨hPI, hVD⟩⟩ := weakly_anchored_has_indistinguishable_distinct_pair p h
  exact absurd hVD (hSound s s' hPI)

end Theorems
end ViableContinuation
