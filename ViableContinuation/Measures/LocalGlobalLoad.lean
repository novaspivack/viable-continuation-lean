import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Transitions
import ViableContinuation.Core.Viability
import ViableContinuation.Core.LocalGlobal

/-!
# ViableContinuation.Measures.LocalGlobalLoad

**Phase III: Local-to-global compatibility load.**

We have binary compatibility (LocalGlobalCompatible) and decoupling (LocalGlobalDecoupled).
This module adds a graded notion: the "load" of bad transitions (viable → pathological).
Supports deficit theorems that need a local burden notion.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Measures

open ViableContinuation.Core

universe u

variable (S : RecordBearingSystem) [HasTransitions S] [HasViability S]

/-- Bad transition: from viable to pathological. -/
def badTransition (s s' : S.State) : Prop :=
  HasTransitions.transition s s' ∧ HasViability.Viable s ∧ HasViability.Pathology S s'

/-- Decoupling set: pairs (s, s') that form bad transitions. -/
def decouplingSet : Set (S.State × S.State) :=
  { p | badTransition S p.1 p.2 }

/-- Local-global load: order-theoretic. Systems with more bad transitions have higher load.
    Minimal: load is Nonempty (has at least one bad transition) vs Empty. -/
def hasLocalGlobalLoad : Prop :=
  ∃ (s s' : S.State), badTransition S s s'

/-!
## Lemma: load equivalent to decoupling
-/
theorem has_load_iff_decoupled :
    hasLocalGlobalLoad S ↔ LocalGlobalDecoupled S := by
  constructor
  · intro ⟨s, s', h⟩
    unfold badTransition at h
    exact ⟨s, s', h.1, h.2.1, h.2.2⟩
  · intro ⟨s, s', h₁, h₂, h₃⟩
    exact ⟨s, s', ⟨h₁, h₂, h₃⟩⟩

/-- Compatibility load level: for graded refinements, a preorder on "amount" of load.
    Placeholder for future use. -/
structure LocalGlobalLoadLevel where
  carrier : Type u
  le : carrier → carrier → Prop
  le_refl : Reflexive le
  le_trans : Transitive le

end Measures
end ViableContinuation
