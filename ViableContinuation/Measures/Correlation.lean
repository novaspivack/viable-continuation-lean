import Mathlib
import ViableContinuation.Core.System
import ViableContinuation.Core.Channels

/-!
# ViableContinuation.Measures.Correlation

**Phase III: Channel correlation / independence hierarchy.**

Structure to distinguish:
- merely multiple channels
- weakly independent channels
- strongly decorrelated channels
- common-mode failure regimes

Not slogan-level: formal bite for correlated failure theorem.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Measures

open ViableContinuation.Core

universe u

variable {S : RecordBearingSystem} [HasChannels S]

/-- Multiple channels: the system has at least two distinct channels.
    (We need decidability or choice to state "distinct" — use Nonempty for minimal.) -/
def hasMultipleChannels : Prop :=
  ∃ ch₁ ch₂ : @HasChannels.Channel S _, ch₁ ≠ ch₂

/-- Joint failure: both channels fail at the same state. -/
def jointFailure (ch₁ ch₂ : @HasChannels.Channel S _) (s : S.State) : Prop :=
  HasChannels.fails s ch₁ ∧ HasChannels.fails s ch₂

/-- Weak independence: failures of ch₁ and ch₂ are not perfectly correlated.
    There exists a state where one fails but not both. (Relational version.) -/
def weaklyIndependent (ch₁ ch₂ : @HasChannels.Channel S _) : Prop :=
  (∃ s, HasChannels.fails s ch₁ ∧ ¬ HasChannels.fails s ch₂) ∨
  (∃ s, ¬ HasChannels.fails s ch₁ ∧ HasChannels.fails s ch₂)

/-- Strongly decorrelated: for every pair of failure events, there are states
    realizing each combination. Refinement: joint failure doesn't imply common cause. -/
def stronglyDecorrelated (ch₁ ch₂ : @HasChannels.Channel S _) : Prop :=
  weaklyIndependent ch₁ ch₂ ∧
  (∃ s, ¬ HasChannels.fails s ch₁ ∧ ¬ HasChannels.fails s ch₂) ∧
  (∃ s, HasChannels.fails s ch₁ ∧ HasChannels.fails s ch₂)

/-- Common-mode failure: a set of channels fails together at some state.
    When the mode fails, many channels fail. -/
def commonModeFailure (chs : Set (@HasChannels.Channel S _)) (s : S.State) : Prop :=
  chs.Nonempty ∧ ∀ ch ∈ chs, HasChannels.fails s ch

/-- Correlated pair: ch₁ and ch₂ are correlated when joint failure is "more likely"
    than independent. Relational: at every state where one fails, the other tends to fail.
    Strong form: whenever ch₁ fails, ch₂ fails. -/
def correlatedAtState (ch₁ ch₂ : @HasChannels.Channel S _) (s : S.State) : Prop :=
  HasChannels.fails s ch₁ → HasChannels.fails s ch₂

/-- Correlated pair (symmetric): failure of either implies failure of both. -/
def correlatedPair (ch₁ ch₂ : @HasChannels.Channel S _) : Prop :=
  ∀ s, HasChannels.fails s ch₁ ↔ HasChannels.fails s ch₂

/-!
## Lemma: correlated pair destroys weak independence
-/
theorem correlated_pair_not_weakly_independent
    {ch₁ ch₂ : @HasChannels.Channel S _} (h : correlatedPair ch₁ ch₂) :
    ¬ weaklyIndependent ch₁ ch₂ := by
  intro hWi
  cases' hWi with hL hR
  · obtain ⟨s, ⟨hF, hN⟩⟩ := hL
    exact hN ((h s).1 hF)
  · obtain ⟨s, ⟨hN, hF⟩⟩ := hR
    exact hN ((h s).2 hF)

/-- Two channels are excessively correlated when they form a correlated pair.
    Loss of independent channels yields fragility (correlated failure theorem). -/
def excessivelyCorrelatedPair (ch₁ ch₂ : @HasChannels.Channel S _) : Prop :=
  correlatedPair ch₁ ch₂

end Measures
end ViableContinuation
