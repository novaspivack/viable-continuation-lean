import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Transitions
import ViableContinuation.Core.Viability
import ViableContinuation.Core.LocalGlobal
import ViableContinuation.Measures.ConstraintCapacity
import ViableContinuation.Measures.TraceCapacity
import ViableContinuation.Measures.LocalGlobalLoad

/-!
# ViableContinuation.Measures.StabilityMargin

**Phase III: Composite stability margin (only if earned).**

Not a fake grand scalar. A tuple of key measures with a combined "sufficient" predicate.
The framework uses a conjunction of structural conditions, not an arbitrary number.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Measures

open ViableContinuation.Core

variable (S : RecordBearingSystem) [HasTransitions S] [HasViability S]

/-- Stability margin: sufficient when constraint capacity, trace capacity, and
    local-global compatibility all hold. Each component is a structural condition.
    No single numeric gauge. -/
structure StabilityMarginSufficient
    [HasConstraints S] [HasConstraintCapacity S] where
  constraintOk : ∀ s : S.State, capacitySufficient s
  traceOk : ∀ s : S.State, TraceSufficient s
  localGlobalOk : LocalGlobalCompatible S

/-- Margin implies compatibility: when the margin is sufficient, the system is
    local-global compatible (by definition). -/
theorem margin_sufficient_has_compatibility
    [HasConstraints S] [HasConstraintCapacity S]
    (m : StabilityMarginSufficient S) :
    LocalGlobalCompatible S :=
  m.localGlobalOk

end Measures
end ViableContinuation
