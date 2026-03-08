import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Transitions
import ViableContinuation.Core.Viability
import ViableContinuation.Core.LocalGlobal
import ViableContinuation.Core.Channels
import ViableContinuation.Core.Constraints
import ViableContinuation.Core.Anchors
import ViableContinuation.Measures.TraceCapacity
import ViableContinuation.Measures.ProxyDetachment
import ViableContinuation.Measures.Correlation
import ViableContinuation.Measures.ConstraintCapacity

/-!
# ViableContinuation.Theorems.Robustness

**Phase IV: Shared system-level robustness notions.**

Holds structural predicates used across foothill theorems. Prevents each theorem
file from inventing its own meta-predicates in isolation. Keep minimal.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Theorems

open ViableContinuation.Core
open ViableContinuation.Measures

universe u

section Diachronic

variable (S : RecordBearingSystem) [HasViability S]

/-- Robust diachronic correction for S: at every state, records suffice to discriminate viability.
    When this fails, the system cannot reliably correct using records alone. -/
def robustDiachronicCorrection : Prop :=
  ∀ s : S.State, ¬ diachronicCorrectionFails s

end Diachronic

section ProxySound

variable (S : RecordBearingSystem) [HasViability S] [HasAnchors S]

/-- Proxy-sound viability discrimination: the proxy never conflates viability-distinct states.
    proxySound p := ∀ s s', proxyIndistinguishable p s s' → ¬viabilityDistinct s s'

    When this fails, the proxy cannot reliably discriminate viable from nonviable states.
-/
def proxySound (p : @HasAnchors.Proxy S _ _) : Prop :=
  ∀ s s' : S.State, proxyIndistinguishable p s s' → ¬ viabilityDistinct s s'

end ProxySound

section ViableContinuation

variable (S : RecordBearingSystem) [HasViability S]

/-- Robust viable continuation for S: no state is pathological.
    When this fails, the system has at least one pathological state and cannot
    claim full viability. Minimal system-level notion for the constraint-deficit
    foothill. -/
def robustViableContinuation : Prop :=
  ∀ s : S.State, HasViability.Viable s

end ViableContinuation

section LocalGlobal

variable (S : RecordBearingSystem) [HasTransitions S] [HasViability S]

/-- Local admissibility guarantees viable continuation: locally admissible transitions
    preserve viability (LocalGlobalCompatible). When this fails, local success does not
    guarantee global viability — the key dynamical pillar of the framework. -/
def localAdmissibilityGuaranteesViableContinuation : Prop :=
  LocalGlobalCompatible S

end LocalGlobal

section ChannelRedundancy

variable (S : RecordBearingSystem) [HasChannels S]

/-- Independent correction available for channel set chs: at every state, at least one
    channel in chs is working. Multiplicity provides protection — when this fails,
    there exists a state where all channels fail (common-mode), and the system
    cannot rely on channel redundancy for correction. -/
def independentCorrectionAvailable (chs : Set (@HasChannels.Channel S _)) : Prop :=
  ∀ s : S.State, ∃ ch ∈ chs, ¬ HasChannels.fails s ch

end ChannelRedundancy

section CapacitySupport

variable (S : RecordBearingSystem) [HasConstraints S] [HasConstraintCapacity S]

/-- Capacity supports viability for S: at every state, effective capacity meets the
    required floor. When this fails, the system has a capacity deficit somewhere
    and cannot sustain viability-preserving continuation. The capacity pillar. -/
def capacitySupportsViability : Prop :=
  ∀ s : S.State, capacitySufficient s

end CapacitySupport

section BoundaryDefect

variable (S : RecordBearingSystem)
  [HasTransitions S] [HasViability S] [HasAnchors S] [HasChannels S]
  [HasConstraints S] [HasConstraintCapacity S]

/-- Boundary defect: any of the four defect families that defeat robust viable continuation.
    Epistemic (weak anchoring), dynamical (decoupling), redundancy (common-mode failure),
    or capacity (deficit). The summit theorems show this is equivalent to schema failure. -/
def BoundaryDefect (p : @HasAnchors.Proxy S _ _) (chs : Set (@HasChannels.Channel S _)) : Prop :=
  weaklyAnchored p ∨
  LocalGlobalDecoupled S ∨
  (∃ s : S.State, commonModeFailure chs s) ∨
  (∃ s : S.State, capacityDeficit s)

end BoundaryDefect

section CompositeSchema

variable (S : RecordBearingSystem)
  [HasTransitions S] [HasViability S] [HasAnchors S] [HasChannels S]
  [HasConstraints S] [HasConstraintCapacity S]

/-- Robust viable continuation schema: all four pillars hold jointly.
    Proxy guidance is sound, local admissibility guides viability, channel redundancy
    provides correction, and capacity supports viability. The composite boundary
    theorem shows that any single deficit defeats this schema. -/
def robustViableContinuationSchema
    (p : @HasAnchors.Proxy S _ _) (chs : Set (@HasChannels.Channel S _)) : Prop :=
  proxySound S p ∧
  localAdmissibilityGuaranteesViableContinuation S ∧
  independentCorrectionAvailable S chs ∧
  capacitySupportsViability S

end CompositeSchema

end Theorems
end ViableContinuation
