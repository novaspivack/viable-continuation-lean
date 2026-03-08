import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Viability
import ViableContinuation.Core.Anchors

/-!
# ViableContinuation.Measures.ProxyDetachment

**Phase III: Anchor fidelity / proxy detachment (formal bite).**

Supports results:
- proxy-indistinguishable but viability-distinct states exist (WeaklyAnchored)
- weak anchoring permits divergence
- stronger anchoring blocks certain pathologies

Order-theoretic: fidelity levels, detachment degree.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Measures

open ViableContinuation.Core

universe u

variable {S : RecordBearingSystem} [HasViability S] [HasAnchors S]

/-- Proxy-indistinguishable states: the proxy gives the same verdict for both. -/
def proxyIndistinguishable (p : @HasAnchors.Proxy S _ _) (s s' : S.State) : Prop :=
  HasAnchors.proxySaysViable s p ↔ HasAnchors.proxySaysViable s' p

/-- Viability-distinct: one is viable, the other is not. -/
def viabilityDistinct (s s' : S.State) : Prop :=
  (HasViability.Viable s ↔ ¬ HasViability.Viable s')

/-- Weakly anchored (re-export): proxy cannot distinguish some viability-distinct states. -/
abbrev weaklyAnchored (p : @HasAnchors.Proxy S _ _) : Prop :=
  ViableContinuation.Core.WeaklyAnchored p

/-- Detachment set: states where the proxy is wrong (proxySaysViable ≠ Viable). -/
def detachmentSet (p : @HasAnchors.Proxy S _ _) : Set S.State :=
  { s | ProxyDetachment s p }

/-- Fidelity level: order-theoretic. Proxy p₁ has fidelity ≥ p₂ when the detachment set
    of p₁ is contained in that of p₂ (p₁ is wrong no more often than p₂). -/
def fidelityLe (p₁ p₂ : @HasAnchors.Proxy S _ _) : Prop :=
  detachmentSet p₁ ⊆ detachmentSet p₂

/-!
## Lemma: weakly anchored implies proxy-indistinguishable viability-distinct pair

This is the key structural fact for the weak anchor foothill theorem.
-/
theorem weakly_anchored_has_indistinguishable_distinct_pair
    (p : @HasAnchors.Proxy S _ _) (h : weaklyAnchored p) :
    ∃ s s', proxyIndistinguishable p s s' ∧ viabilityDistinct s s' := by
  unfold weaklyAnchored at h
  unfold ViableContinuation.Core.WeaklyAnchored at h
  obtain ⟨s, s', ⟨hVD, hPI⟩⟩ := h
  use s, s'
  exact ⟨hPI, hVD⟩

/-- Strong anchoring: proxy has full fidelity at all states (no detachment). -/
def stronglyAnchored (p : @HasAnchors.Proxy S _ _) : Prop :=
  ∀ s, AnchorFidelity s p

theorem strongly_anchored_not_weakly_anchored
    (p : @HasAnchors.Proxy S _ _) (h : stronglyAnchored p) :
    ¬ weaklyAnchored p := by
  intro hW
  obtain ⟨s, s', ⟨hPI, hVD⟩⟩ := weakly_anchored_has_indistinguishable_distinct_pair p hW
  have hFidS := h s
  have hFidS' := h s'
  unfold AnchorFidelity at hFidS hFidS'
  by_cases hV : HasViability.Viable s
  · have hPS := hFidS.2 hV
    have hPS' : HasAnchors.proxySaysViable s' p := hPI.1 hPS
    exact absurd (hFidS'.1 hPS') (hVD.1 hV)
  · have hVS' : HasViability.Viable s' := by
      by_contra hNs'
      exact absurd (hVD.2 hNs') hV
    have hPS' := hFidS'.2 hVS'
    have hPS : HasAnchors.proxySaysViable s p := hPI.2 hPS'
    exact absurd (hFidS.1 hPS) hV

end Measures
end ViableContinuation
