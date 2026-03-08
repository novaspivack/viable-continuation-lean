import Mathlib

/-!
# ViableContinuation.Core.System

**Phase II: Abstract Ontology — System structure.**

Minimal bundle for a record-bearing system whose continuation depends on reconciling
local transitions with whole-system viability. Abstract and domain-agnostic.

- `State` : configurations the system can occupy
- `Record` : trace/record substrate (what can be recorded for diachronic correction)
- `recordAt` : which records are present at which states
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Core

universe u v

/-- A record-bearing system has states, a trace substrate, and a relation
    recording which traces hold at which states. -/
structure RecordBearingSystem where
  State : Type u
  Record : Type v
  recordAt : State → Record → Prop

/-- Alias for concise use. -/
abbrev VCSystem := RecordBearingSystem

namespace RecordBearingSystem

variable (S : RecordBearingSystem)

/-- A state supports (has) a record when that record holds at it. -/
def supportsRecord (s : S.State) (r : S.Record) : Prop :=
  S.recordAt s r

/-- Records at a state: the set of records present. -/
def recordsAt (s : S.State) : Set S.Record :=
  { r | S.recordAt s r }

end RecordBearingSystem

end Core
end ViableContinuation
