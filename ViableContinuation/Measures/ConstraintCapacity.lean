import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Constraints
import ViableContinuation.Core.Viability

/-!
# ViableContinuation.Measures.ConstraintCapacity

**Phase III: Constraint capacity (theorem-usable).**

Constraint capacity must be more than a name. We use an order-theoretic interpretation:
a preorder on capacity levels, with a notion of "effective capacity at a state" and
"capacity deficit" (capacity below required floor). Supports: transition pressure
exceeds constraint capacity ⇒ viable continuation fails.

**Not** "enough constraints" — we formalize coverage/admissibility-bound.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Measures

open ViableContinuation.Core

universe u

variable {S : RecordBearingSystem} [HasConstraints S]

/-- Constraint capacity structure: order-theoretic levels and effective capacity per state.
    Capacity is a *coverage* or *admissibility-bound* notion: higher capacity =
    more constraints satisfied or larger admissible load bound. -/
class HasConstraintCapacity (S : RecordBearingSystem) [HasConstraints S] where
  CapacityLevel : Type u
  capacityLe : CapacityLevel → CapacityLevel → Prop
  capacityLe_refl : Reflexive capacityLe
  capacityLe_trans : Transitive capacityLe
  /-- Effective capacity at a state: how much the system can enforce there. -/
  effectiveCapacity : S.State → CapacityLevel
  /-- Required floor: capacity below this cannot sustain viable continuation. -/
  requiredFloor : CapacityLevel

/-- Capacity deficit at state s: effective capacity is below the required floor. -/
def capacityDeficit [HasConstraintCapacity S] (s : S.State) : Prop :=
  ¬ HasConstraintCapacity.capacityLe HasConstraintCapacity.requiredFloor (HasConstraintCapacity.effectiveCapacity s)

/-- Capacity sufficient at s: no deficit. -/
def capacitySufficient [HasConstraintCapacity S] (s : S.State) : Prop :=
  HasConstraintCapacity.capacityLe HasConstraintCapacity.requiredFloor (HasConstraintCapacity.effectiveCapacity s)

namespace HasConstraintCapacity

variable (S : RecordBearingSystem) [HasConstraints S] [HasConstraintCapacity S]

/-- Coverage interpretation: capacity increases when more constraints are satisfied.
    Optional axiom for instances that define effectiveCapacity from satisfied set. -/
def capacityMonotoneInConstraints : Prop :=
  ∀ (s s' : S.State),
    (∀ c : @HasConstraints.Constraint S _,
      HasConstraints.satisfied s c → HasConstraints.satisfied s' c) →
    capacityLe (effectiveCapacity s) (effectiveCapacity s')

end HasConstraintCapacity

/-!
## Lemma: deficit and viability

When capacity is in deficit, the system cannot sustain constraints needed for viability.
This is the bridge to the constraint deficit foothill theorem.
-/
section Lemmas

variable (S : RecordBearingSystem) [HasConstraints S] [HasConstraintCapacity S] [HasViability S]

/-- Deficit implies pathology, when sufficient capacity is necessary for viability.
    Key link for the constraint deficit foothill theorem. -/
theorem capacityDeficit_precludes_viability
    (h : ∀ s : S.State, HasViability.Viable s → capacitySufficient s) :
    ∀ s : S.State, capacityDeficit s → HasViability.Pathology S s := by
  intro s hDef hVia
  exact absurd (h s hVia) hDef

end Lemmas

end Measures
end ViableContinuation
