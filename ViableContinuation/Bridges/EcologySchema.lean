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
# ViableContinuation.Bridges.EcologySchema

**Phase VII: Biodiversity/ecology bridge.** Minimal toy instantiation.
Reference: 07_Interpretation_Bridges/07_Biodiversity_and_Ecology.md

State 0 = ecosystem resilience; State 1 = local success decoupled from ecosystem-level viability.
-/

set_option autoImplicit false

namespace ViableContinuation
namespace Bridges

open ViableContinuation.Core
open ViableContinuation.Measures

universe u

def EcologyToySys : RecordBearingSystem where
  State := Fin 2
  Record := Fin 1
  recordAt := fun _ _ => True

namespace EcologyToySys

def s0 : Fin 2 := 0
def s1 : Fin 2 := 1

instance : HasTransitions EcologyToySys where
  transition := fun s s' => s = s0 ∧ s' = s1

instance : HasViability EcologyToySys where
  Viable := fun s => s = s0

instance : HasAnchors EcologyToySys where
  Proxy := Fin 1
  proxySaysViable := fun s _ => s = s0

instance : HasChannels EcologyToySys where
  Channel := Fin 2
  fails := fun s _ => s = s1

instance : HasConstraints EcologyToySys where
  Constraint := Fin 1
  satisfied := fun s _ => s = s0

instance : HasConstraintCapacity EcologyToySys where
  CapacityLevel := Nat
  capacityLe := Nat.le
  capacityLe_refl := Nat.le_refl
  capacityLe_trans := fun _ _ _ => Nat.le_trans
  effectiveCapacity := fun s => match s.val with | 0 => 1 | _ => 0
  requiredFloor := 1

instance : Bridges.BridgeComplete EcologyToySys where
  domainWf := trivial

theorem ecology_toy_decoupled : LocalGlobalDecoupled EcologyToySys := by
  unfold LocalGlobalDecoupled
  use s0, s1
  simp only [HasTransitions.transition, HasViability.Viable, HasViability.Pathology, s0, s1]
  constructor
  · constructor <;> trivial
  · constructor
    · trivial
    · intro h; have := congr_arg Fin.val h; omega

def ecologyBridge : DomainBridge EcologyToySys where
  domainName := "biodiversity and ecology"
  stateInterpretation := "ecosystem configuration; species composition"
  recordInterpretation := "adaptive repertoires, evolutionary memory"
  viabilityInterpretation := "ecosystem resilience; continued functioning"

end EcologyToySys

end Bridges
end ViableContinuation
