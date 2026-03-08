import Mathlib
import ViableContinuation.Core.System

/-!
# ViableContinuation.Core.Traces

**Phase II: Abstract Ontology — Trace / record substrate.**

Records provide the diachronic substrate for correction and reconciliation.
"Trace capacity" (Phase III) measures sufficiency for diachronic correction.
The base `RecordBearingSystem` already has `Record` and `recordAt`; this module
adds derived notions for trace sufficiency and correction.
-/
set_option autoImplicit false

namespace ViableContinuation
namespace Core

universe u v

variable {S : RecordBearingSystem}

/-- A trace is a sequence of records (diachronic view).
    Minimal: a list of records. -/
def Trace (S : RecordBearingSystem) :=
  List S.Record

/-- A state has sufficient trace for correction when it supports enough records
    to permit diachronic reconciliation. Minimal: nonempty records.
    Phase III will add a proper trace-capacity measure. -/
def hasTraceFloor (S : RecordBearingSystem) (s : S.State) : Prop :=
  Set.Nonempty (S.recordsAt s)

/-- Trace capacity carrier (for order-theoretic comparison in Phase III). -/
structure TraceCapacityLevel (S : RecordBearingSystem) where
  carrier : Type u

end Core
end ViableContinuation
