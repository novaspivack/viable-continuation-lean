import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Transitions
import ViableContinuation.Core.Viability

/-!
# ViableContinuation.Core.LocalGlobal

**Phase II: Abstract Ontology — Local-to-global compatibility.**

Local transitions can be "admissible" (locally consistent) but lead to globally
pathological outcomes when local and global constraints are insufficiently coupled.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Core

universe u

variable (S : RecordBearingSystem) [HasTransitions S] [HasViability S]

/-- Local admissibility: a transition is locally admissible if it satisfies
    local constraints. Minimal: all transitions are locally admissible;
    refinement adds local constraint checks. -/
def locallyAdmissible (s s' : S.State) : Prop :=
  HasTransitions.transition s s'

/-- Local-to-global compatibility: locally admissible transitions preserve viability.
    When this fails, local success can yield global pathology. -/
def LocalGlobalCompatible : Prop :=
  ∀ (s s' : S.State), HasTransitions.transition s s' → HasViability.Viable s → HasViability.Viable s'

/-- Local-global decoupling: there exist locally admissible transitions from viable
    states to pathological states. -/
def LocalGlobalDecoupled : Prop :=
  ∃ (s s' : S.State), HasTransitions.transition s s' ∧ HasViability.Viable s ∧ HasViability.Pathology S s'

/-- A trajectory is globally viable when every state in it is viable. -/
def trajectoryViable (π : List S.State) : Prop :=
  ∀ s ∈ π, HasViability.Viable s

end Core
end ViableContinuation
