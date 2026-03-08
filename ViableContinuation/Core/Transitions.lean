import Mathlib
import ViableContinuation.Core.System

/-!
# ViableContinuation.Core.Transitions

**Phase II: Abstract Ontology — Local transition space.**

Transitions between states represent local dynamics. "Transition pressure" (Phase III)
will measure the load these transitions impose on constraint/trace capacity.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Core

universe u

variable {S : RecordBearingSystem}

/-- A transition structure extends a record-bearing system with a local transition relation.
    `transition s s'` means the system can move from `s` to `s'` in one local step. -/
class HasTransitions (S : RecordBearingSystem) where
  transition : S.State → S.State → Prop

/-- A trajectory is a finite or infinite sequence of states connected by transitions.
    For simplicity we use `List` for finite trajectories. -/
def Trajectory (S : RecordBearingSystem) [HasTransitions S] :=
  List S.State

namespace HasTransitions

variable (S : RecordBearingSystem) [HasTransitions S]

/-- A list of states forms a valid path when consecutive states are related by transition. -/
def Path (π : List S.State) : Prop :=
  match π with
  | [] => True
  | [_] => True
  | a :: b :: rest => HasTransitions.transition a b ∧ Path (b :: rest)

/-- A transition is local (trivial case: any transition is local; refinement later). -/
def localTransition (s s' : S.State) : Prop :=
  HasTransitions.transition s s'

end HasTransitions

end Core
end ViableContinuation
