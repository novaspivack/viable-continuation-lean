import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Transitions
import ViableContinuation.Core.Viability
import ViableContinuation.Core.Anchors
import ViableContinuation.Measures.ProxyDetachment

/-!
# ViableContinuation.Theorems.ProxyDrift

**Phase V Ridge 1: Proxy Drift Theorem.**

Strengthens the weak-anchor foothill: when the proxy-indistinguishable viability-distinct
pair is connected by a transition, proxy-guided continuation can lead to pathology.
The proxy cannot warn you because it conflates the states.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Theorems

open ViableContinuation.Core
open ViableContinuation.Measures

universe u

variable (S : RecordBearingSystem) [HasTransitions S] [HasViability S] [HasAnchors S]

/-- Proxy-guided path diverges from viability: there exists a path containing both
    viable and pathological states, but the proxy cannot tell them apart (gives same
    verdict for all states in the path). Proxy-guided continuation can lead to pathology. -/
def proxyGuidedPathDiverges (p : @HasAnchors.Proxy S _ _) : Prop :=
  ∃ π : List S.State,
    HasTransitions.Path S π ∧
    (∃ s ∈ π, HasViability.Viable s) ∧
    (∃ s ∈ π, HasViability.Pathology S s) ∧
    (∀ a ∈ π, ∀ b ∈ π, proxyIndistinguishable p a b)

/-- Transition connects indistinguishable pair: the proxy-indistinguishable viability-distinct
    pair from weak anchoring has a transition between them (viable → pathological or vice versa). -/
def transitionConnectsIndistinguishablePair (p : @HasAnchors.Proxy S _ _) : Prop :=
  ∃ s s', proxyIndistinguishable p s s' ∧ viabilityDistinct s s' ∧
    (HasTransitions.transition s s' ∨ HasTransitions.transition s' s)

/-- Proxy Drift Theorem (ridge).

    When the proxy is weakly anchored and the indistinguishable viability-distinct pair
    is connected by a transition, proxy-guided continuation can diverge from actual viability:
    there exists a path with both viable and pathological states that the proxy conflates.
-/
theorem proxy_drift
    (p : @HasAnchors.Proxy S _ _)
    (_hWeak : weaklyAnchored p)
    (hConn : transitionConnectsIndistinguishablePair S p) :
    proxyGuidedPathDiverges S p := by
  obtain ⟨s, s', ⟨hProxyIndist, ⟨hViabilityDistinct, hTrans⟩⟩⟩ := hConn
  have hOneViable : HasViability.Viable s ∨ HasViability.Viable s' := by
    by_cases h : HasViability.Viable s
    · exact Or.inl h
    · exact Or.inr (Classical.by_contradiction (fun hNs' => absurd (hViabilityDistinct.2 hNs') h))
  have hOnePathol : HasViability.Pathology S s ∨ HasViability.Pathology S s' := by
    unfold HasViability.Pathology
    by_cases h : HasViability.Viable s
    · exact Or.inr (hViabilityDistinct.1 h)
    · exact Or.inl h
  cases' hTrans with hFwd hBwd
  · refine ⟨[s, s'], ⟨hFwd, trivial⟩, ?_, ?_, ?_⟩
    · exact hOneViable.elim (fun hV => ⟨s, by simp, hV⟩) (fun hV => ⟨s', by simp, hV⟩)
    · exact hOnePathol.elim (fun hP => ⟨s, by simp, hP⟩) (fun hP => ⟨s', by simp, hP⟩)
    · intro a ha b hb
      simp only [List.mem_cons, List.mem_nil_iff, or_false] at ha hb
      rcases ha with rfl | rfl <;> rcases hb with rfl | rfl
      · exact Iff.rfl
      · exact hProxyIndist
      · exact Iff.symm hProxyIndist
      · exact Iff.rfl
  · refine ⟨[s', s], ⟨hBwd, trivial⟩, ?_, ?_, ?_⟩
    · exact hOneViable.elim (fun hV => ⟨s, by simp, hV⟩) (fun hV => ⟨s', by simp, hV⟩)
    · exact hOnePathol.elim (fun hP => ⟨s, by simp, hP⟩) (fun hP => ⟨s', by simp, hP⟩)
    · intro a ha b hb
      simp only [List.mem_cons, List.mem_nil_iff, or_false] at ha hb
      rcases ha with rfl | rfl <;> rcases hb with rfl | rfl
      · exact Iff.rfl
      · exact Iff.symm hProxyIndist
      · exact hProxyIndist
      · exact Iff.rfl
