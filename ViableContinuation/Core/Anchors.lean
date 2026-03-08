import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Viability

/-!
# ViableContinuation.Core.Anchors

**Phase II: Abstract Ontology — Anchor / proxy-grounding relation.**

Proxies are local stand-ins for global viability. "Anchor fidelity" means the proxy
tracks true viability; "proxy detachment" means drift. Minimal: proxies as
predicates, fidelity as agreement with Viable.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Core

universe u

variable {S : RecordBearingSystem}

/-- A system has proxy/anchor structure: local indicators of global viability. -/
class HasAnchors (S : RecordBearingSystem) [HasViability S] where
  Proxy : Type u
  /-- The proxy's judgment: does it indicate viability at this state? -/
  proxySaysViable : S.State → Proxy → Prop

/-- Anchor fidelity: the proxy's judgment agrees with actual viability. -/
def AnchorFidelity [HasViability S] [HasAnchors S] (s : S.State) (p : @HasAnchors.Proxy S _ _) : Prop :=
  HasAnchors.proxySaysViable s p ↔ HasViability.Viable s

/-- Proxy detachment: the proxy drifts from true viability (negation of fidelity). -/
def ProxyDetachment [HasViability S] [HasAnchors S] (s : S.State) (p : @HasAnchors.Proxy S _ _) : Prop :=
  ¬ AnchorFidelity s p

/-- Weak anchor: there exist viability-distinct states that the proxy cannot distinguish. -/
def WeaklyAnchored [HasViability S] [HasAnchors S] (p : @HasAnchors.Proxy S _ _) : Prop :=
  ∃ s s', (HasViability.Viable s ↔ ¬ HasViability.Viable s') ∧
    (HasAnchors.proxySaysViable s p ↔ HasAnchors.proxySaysViable s' p)

end Core
end ViableContinuation
