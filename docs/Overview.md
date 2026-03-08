# Viable Continuation Under Constraint — Overview

## Project Scope

The **Viable Continuation Program (VCP)** creates a new Lean library for a general theory of **viable continuation under constraint**. The target is a **single abstract theorem family** from which domain claims follow as interpretation theorems, not a collection of domain-specific analogies.

**Core ambition:** Prove a general viability-boundary framework such that AGI, law, institutions, markets, biology, ecology, civilizations, science, and (where admissible) physical regimes can be treated as instantiations of one abstract spine.

## Design Principles

1. **Abstract-first, not domain-first.** Build the abstract spine before domain bridges.
2. **No theorem cosplay.** No grand prose claims without abstract framework support.
3. **No duplicate machinery.** Reuse nems-lean and reflexive-closure-lean where appropriate.
4. **No unjustified fresh axioms.** New definitions allowed; substantive axioms isolated and named.
5. **Zero sorry target.** Temporary sorrys must be marked, tracked, and eliminated.

## Dependency Policy

- **Core** (`Core/`, `Measures/`, `Theorems/`): Mathlib only (plus minimal internal).
- **Bridges**: May import nems-lean; ReflexiveClosureInstantiation may import reflexive-closure-lean if required.
- **Clean abstraction**: The core does not depend on the full NEMS ontology unless unavoidable.

## Phase Plan

| Phase | Objective | Status |
|-------|-----------|--------|
| I | Initialization and grounding | ✓ |
| II | Abstract ontology specification | ✓ |
| III | Viability, capacity, deficit measures | ✓ |
| IV | Foothill theorems | ✓ |
| V | Ridge theorems | ✓ |
| VI | Summit theorem | ✓ |
| VII | Interpretation bridges (nine domain schemas) | ✓ |
| VII+ | FrontierPrinciples — frontier canon → defect witnesses | ✓ |
| VIII | Flagship paper + Principles paper | ✓ |

## Preferred Vocabulary

- local transitions, transition pressure  
- constraint capacity, trace capacity, channel family  
- channel independence, correlated failure  
- anchor fidelity, proxy detachment  
- local-to-global compatibility, global viability  
- viable continuation, pathology, fragility, collapse, constraint deficit  

## Phase VII+ FrontierPrinciples

`Bridges.FrontierPrinciples` maps a canonical frontier-principles canon (AGI, civilization, pluralism, war, science, biology, ecology, markets) to defect witnesses in each domain bridge. Each principle is proved to satisfy `LocalGlobalDecoupled` and common-mode failure per the abstract spine. See **FRONTIER_BRIDGE_TARGET_LEDGER.md** in `71_71.1_Viable_Continuation_Program/10_Status_and_Review/` for the full ledger.

## References

- **VIABLE_CONTINUATION_PROGRAM.md** — Full execution spec
- **CODING_PROTOCOLS.md** — NEMS suite coding protocols
- **nems-lean** — Abstract-core libraries (Closure, SelectorStrength, etc.)
- **FRONTIER_BRIDGE_TARGET_LEDGER.md** — Frontier principles ↔ defect witnesses mapping
