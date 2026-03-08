import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Transitions

/-!
# ViableContinuation.Measures.TransitionPressure

**Phase III: Transition pressure.**

Measures when local transitions are "too unconstrained" or "too abundant" relative
to system control. Order-theoretic: a preorder on pressure levels, and a relation
between states and pressure. No numeric scalars unless necessary.

**Theorem target:** Constraint deficit (pressure exceeds capacity) ⇒ viable continuation fails.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Measures

open ViableContinuation.Core

universe u

variable {S : RecordBearingSystem} [HasTransitions S]

/-- A transition-pressure structure assigns to each state a level of "pressure"
    (how much the transition space loads the system). Preorder: lower is better. -/
class HasTransitionPressure (S : RecordBearingSystem) [HasTransitions S] where
  PressureLevel : Type u
  pressureLe : PressureLevel → PressureLevel → Prop
  pressureLe_refl : Reflexive pressureLe
  pressureLe_trans : Transitive pressureLe
  pressureAt : S.State → PressureLevel

/-- State s has pressure no higher than level L when pressureAt s ≤ L. -/
def pressureBoundedBy [HasTransitionPressure S] (s : S.State) (L : @HasTransitionPressure.PressureLevel S _ _) : Prop :=
  HasTransitionPressure.pressureLe (HasTransitionPressure.pressureAt s) L

/-- State s has higher pressure than s' when s's pressure dominates s''s. -/
def pressureDominates [HasTransitionPressure S] (s s' : S.State) : Prop :=
  ¬ HasTransitionPressure.pressureLe (HasTransitionPressure.pressureAt s) (HasTransitionPressure.pressureAt s')

namespace HasTransitionPressure

variable (S : RecordBearingSystem) [HasTransitions S] [HasTransitionPressure S]

/-- High pressure: a state has high pressure when it exceeds a given threshold. -/
def highPressure (L : @HasTransitionPressure.PressureLevel S _ _) (s : S.State) : Prop :=
  ¬ pressureLe (pressureAt s) L

end HasTransitionPressure

/-!
## Lemma: pressure and outgoing transitions

If pressure is defined from transition count (concrete instance), more outgoing
transitions imply higher pressure. Here we state a compatibility property:
a system that assigns pressure from a "transition load" notion respects that
load increases with transition availability.
-/
section Lemmas

variable (S : RecordBearingSystem) [HasTransitions S] [HasTransitionPressure S]

/-- When s' has at least the outgoing transitions of s, pressure at s' is not lower.
    Concrete instances link pressure to transition availability. -/
def pressureMonotoneInTransitions : Prop :=
  ∀ (s s' : S.State),
    (∀ t, HasTransitions.transition s t → HasTransitions.transition s' t) →
    HasTransitionPressure.pressureLe (HasTransitionPressure.pressureAt s) (HasTransitionPressure.pressureAt s')

end Lemmas

end Measures
end ViableContinuation
