import ViableContinuation.Core.System
import ViableContinuation.Core.Transitions
import ViableContinuation.Core.Viability
import ViableContinuation.Core.Anchors
import ViableContinuation.Core.Channels
import ViableContinuation.Core.Constraints
import ViableContinuation.Measures.ConstraintCapacity

/-!
# ViableContinuation.Bridges.BridgeSchema

**Phase VII: Generic bridge interface.**

A bridge is an interpretation of the abstract viable continuation ontology into a domain.
The abstract framework is polymorphic over `S : RecordBearingSystem`; a domain bridge
supplies a concrete S built from domain-specific types, together with the required
instances. Reference: FINAL_PHASE.md §6, Paper 71 Appendix B, 07_Interpretation_Bridges/.
-/

set_option autoImplicit false

namespace ViableContinuation
namespace Bridges

open ViableContinuation.Core
open ViableContinuation.Measures

universe u

/-- A domain bridge packages a RecordBearingSystem S that instantiates the abstract
    ontology for a named domain. The system S is built from domain-specific types;
    the bridge documents the interpretation mapping.

    The key requirement: S must satisfy the typeclass constraints needed for the
    summit theorems (HasTransitions, HasViability, HasAnchors, HasChannels,
    HasConstraints, HasConstraintCapacity). Domain-specific bridge modules
    (AGISchema, LawSchema, BioSchema) construct such S and supply the instances.

    This structure does not add new theorems; it provides the interface for
    domain instantiation. See the markdown bridge notes in 07_Interpretation_Bridges/
    for the full ontology and defect mappings.
-/
structure DomainBridge (S : RecordBearingSystem) where
  /-- Domain name for documentation. -/
  domainName : String
  /-- Short description of the State interpretation. -/
  stateInterpretation : String := "states"
  /-- Short description of the Record interpretation. -/
  recordInterpretation : String := "records/traces"
  /-- Short description of the viability interpretation. -/
  viabilityInterpretation : String := "viability"

/-- A bridge is complete when S carries all required structure for the summit.
    This is a typeclass constraint: the bridge module must supply instances.
    We do not re-state the full instance telescope here; it appears in the
    concrete bridge modules.
-/
class BridgeComplete (S : RecordBearingSystem)
    [HasTransitions S] [HasViability S] [HasAnchors S] [HasChannels S]
    [HasConstraints S] [HasConstraintCapacity S] where
  /-- Placeholder for domain-specific well-formedness. -/
  domainWf : True := trivial

end Bridges
end ViableContinuation
