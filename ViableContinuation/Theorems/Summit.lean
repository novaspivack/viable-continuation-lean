import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Transitions
import ViableContinuation.Core.Viability
import ViableContinuation.Core.LocalGlobal
import ViableContinuation.Core.Anchors
import ViableContinuation.Core.Channels
import ViableContinuation.Core.Constraints
import ViableContinuation.Measures.ProxyDetachment
import ViableContinuation.Measures.ConstraintCapacity
import ViableContinuation.Measures.Correlation
import ViableContinuation.Theorems.Robustness
import ViableContinuation.Theorems.WeakAnchorUnsoundness
import ViableContinuation.Theorems.LocalGlobalPathology
import ViableContinuation.Theorems.CorrelatedFailure
import ViableContinuation.Theorems.ConstraintDeficit
import ViableContinuation.Theorems.CompositeBoundary

/-!
# ViableContinuation.Theorems.Summit

**Phase VI: Summit theorems — capstone of the viable continuation framework.**

The summit sits above the ridge: it introduces the named `BoundaryDefect` abstraction
and proves both the necessary-conditions theorem (positive face) and the general
viability boundary theorem (negative face). These are the flagship results.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Theorems

open ViableContinuation.Core
open ViableContinuation.Measures

universe u

variable (S : RecordBearingSystem)
  [HasTransitions S] [HasViability S] [HasAnchors S] [HasChannels S]
  [HasConstraints S] [HasConstraintCapacity S]

/-- Summit B: Necessary Conditions for Robust Viable Continuation.

    When the robust viable continuation schema holds, no boundary defect exists.
    The four pillars (proxy soundness, local compatibility, independent correction,
    capacity support) jointly exclude all four defect families. This is the positive
    summit face: structural robustness implies the absence of boundary-breaking defects.
-/
theorem necessary_conditions_for_robust_viable_continuation
    (p : @HasAnchors.Proxy S _ _) (chs : Set (@HasChannels.Channel S _))
    (hSchema : robustViableContinuationSchema S p chs) :
    ¬ BoundaryDefect S p chs := by
  intro hDefect
  unfold BoundaryDefect at hDefect
  obtain ⟨hProxy, hLocal, hChannel, hCapacity⟩ := hSchema
  cases hDefect with
  | inl hWeak =>
    exact weak_anchor_unsoundness S p hWeak hProxy
  | inr hRest =>
    cases hRest with
    | inl hDec =>
      exact local_global_pathology S hDec hLocal
    | inr hRest' =>
      cases hRest' with
      | inl hCM =>
        exact correlated_failure S chs hCM hChannel
      | inr hCap =>
        exact constraint_deficit S hCap hCapacity

/-- Summit C: General Viability Boundary Theorem.

    When a boundary defect exists, the robust viable continuation schema fails.
    Any of the four defect families — weak anchoring, decoupling, common-mode failure,
    capacity deficit — is sufficient to cross the viability boundary. This is the
    negative summit face: the flagship boundary theorem.

    Derived from the composite ridge theorem by reframing through the named
    BoundaryDefect abstraction.
-/
theorem general_viability_boundary
    (p : @HasAnchors.Proxy S _ _) (chs : Set (@HasChannels.Channel S _))
    (hDefect : BoundaryDefect S p chs) :
    ¬ robustViableContinuationSchema S p chs :=
  composite_boundary S p chs hDefect

end Theorems
end ViableContinuation
