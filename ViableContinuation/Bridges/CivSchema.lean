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
# ViableContinuation.Bridges.CivSchema

**Phase VII: Civilization/markets bridge.** Minimal toy instantiation.
Reference: 07_Interpretation_Bridges/04_Civilization_Governance_and_Markets.md

State 0 = long-horizon viable; State 1 = local optimization decoupled from civilizational viability.
-/

set_option autoImplicit false

namespace ViableContinuation
namespace Bridges

open ViableContinuation.Core
open ViableContinuation.Measures

universe u

def CivToySys : RecordBearingSystem where
  State := Fin 2
  Record := Fin 1
  recordAt := fun _ _ => True

namespace CivToySys

def s0 : Fin 2 := 0
def s1 : Fin 2 := 1

instance : HasTransitions CivToySys where
  transition := fun s s' => s = s0 ∧ s' = s1

instance : HasViability CivToySys where
  Viable := fun s => s = s0

instance : HasAnchors CivToySys where
  Proxy := Fin 1
  proxySaysViable := fun s _ => s = s0

instance : HasChannels CivToySys where
  Channel := Fin 2
  fails := fun s _ => s = s1

instance : HasConstraints CivToySys where
  Constraint := Fin 1
  satisfied := fun s _ => s = s0

instance : HasConstraintCapacity CivToySys where
  CapacityLevel := Nat
  capacityLe := Nat.le
  capacityLe_refl := Nat.le_refl
  capacityLe_trans := fun _ _ _ => Nat.le_trans
  effectiveCapacity := fun s => match s.val with | 0 => 1 | _ => 0
  requiredFloor := 1

instance : Bridges.BridgeComplete CivToySys where
  domainWf := trivial

theorem civ_toy_decoupled : LocalGlobalDecoupled CivToySys := by
  unfold LocalGlobalDecoupled
  use s0, s1
  simp only [HasTransitions.transition, HasViability.Viable, HasViability.Pathology, s0, s1]
  constructor
  · constructor <;> trivial
  · constructor
    · trivial
    · intro h; have := congr_arg Fin.val h; omega

def civBridge : DomainBridge CivToySys where
  domainName := "civilization-scale systems, governance, markets"
  stateInterpretation := "institutional, economic, or political configuration"
  recordInterpretation := "archives, legal memory, governance records"
  viabilityInterpretation := "long-horizon resilience, correction-preserving continuation"

end CivToySys

end Bridges
end ViableContinuation
