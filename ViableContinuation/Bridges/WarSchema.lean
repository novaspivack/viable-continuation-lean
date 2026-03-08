import Mathlib.Data.Fin.Basic
import ViableContinuation.Core.System
import ViableContinuation.Core.Transitions
import ViableContinuation.Core.Constraints
import ViableContinuation.Core.Traces
import ViableContinuation.Core.Channels
import ViableContinuation.Core.Anchors
import ViableContinuation.Core.LocalGlobal
import ViableContinuation.Core.Viability
import ViableContinuation.Measures.ConstraintCapacity
import ViableContinuation.Bridges.BridgeSchema

/-!
# ViableContinuation.Bridges.WarSchema

**Phase VII: War/defense bridge.** Minimal toy instantiation.
Reference: 07_Interpretation_Bridges/05_War_National_Security_and_Defense.md

State 0 = strategic viability; State 1 = tactical success decoupled from strategic stability.
-/

set_option autoImplicit false

namespace ViableContinuation
namespace Bridges

open ViableContinuation.Core
open ViableContinuation.Measures

universe u

def WarToySys : RecordBearingSystem where
  State := Fin 2
  Record := Fin 1
  recordAt := fun _ _ => True

namespace WarToySys

def s0 : Fin 2 := 0
def s1 : Fin 2 := 1

instance : HasTransitions WarToySys where
  transition := fun s s' => s = s0 ∧ s' = s1

instance : HasViability WarToySys where
  Viable := fun s => s = s0

instance : HasAnchors WarToySys where
  Proxy := Fin 1
  proxySaysViable := fun s _ => s = s0

instance : HasChannels WarToySys where
  Channel := Fin 2
  fails := fun s _ => s = s1

instance : HasConstraints WarToySys where
  Constraint := Fin 1
  satisfied := fun s _ => s = s0

instance : HasConstraintCapacity WarToySys where
  CapacityLevel := Nat
  capacityLe := Nat.le
  capacityLe_refl := Nat.le_refl
  capacityLe_trans := fun _ _ _ => Nat.le_trans
  effectiveCapacity := fun s => match s.val with | 0 => 1 | _ => 0
  requiredFloor := 1

instance : Bridges.BridgeComplete WarToySys where
  domainWf := trivial

theorem war_toy_decoupled : LocalGlobalDecoupled WarToySys := by
  unfold LocalGlobalDecoupled
  use s0, s1
  simp only [HasTransitions.transition, HasViability.Viable, HasViability.Pathology, s0, s1]
  constructor
  · constructor <;> trivial
  · constructor
    · trivial
    · intro h; have := congr_arg Fin.val h; omega

def warBridge : DomainBridge WarToySys where
  domainName := "war, national security, defense"
  stateInterpretation := "strategic or operational configuration"
  recordInterpretation := "intelligence archives, command memory"
  viabilityInterpretation := "strategic stability; mission-preserving continuation"

end WarToySys

end Bridges
end ViableContinuation
