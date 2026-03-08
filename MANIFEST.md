# viable-continuation-lean — Artifact Manifest

**Status:** Phase VI (Summit) complete  
**Date:** March 8, 2026  
**Lean version:** leanprover/lean4:v4.29.0-rc3  
**Mathlib version:** v4.29.0-rc3  

## Phase I Deliverables

- [x] Repo exists at `~/viable-continuation-lean`
- [x] Symlink in NEMS_PAPERS points to repo
- [x] Library builds successfully from short path
- [x] Directory structure matches spec
- [x] Initial docs (README, MANIFEST, ARTIFACT, docs/Overview)

## Phase II Deliverables

- [x] RecordBearingSystem (State, Record, recordAt)
- [x] HasTransitions (transition, Path)
- [x] HasViability (Viable, Pathology, Fragility, Collapse)
- [x] HasConstraints (Constraint, satisfied, ConstraintCapacity)
- [x] Traces (Trace, hasTraceFloor)
- [x] HasChannels (Channel, fails, ChannelIndependent, CorrelatedFailure)
- [x] HasAnchors (Proxy, AnchorFidelity, ProxyDetachment, WeaklyAnchored)
- [x] LocalGlobal (LocalGlobalCompatible, LocalGlobalDecoupled, trajectoryViable)
- [x] docs/Spine.md (primitive justification)
- [x] Ontology audit (02_Abstract_Ontology/ONTOLOGY_AUDIT.md)

## Theorem Catalog

### Phase III measure lemmas (calibration)

| Module | Lemma | Statement |
|--------|-------|-----------|
| TraceCapacity | `not_hasTraceFloor_implies_diachronic_correction_fails` | ¬hasTraceFloor s → diachronicCorrectionFails s |
| Correlation | `correlated_pair_not_weakly_independent` | correlatedPair → ¬weaklyIndependent |
| ProxyDetachment | `weakly_anchored_has_indistinguishable_distinct_pair` | weaklyAnchored p → ∃ proxy-indistinguishable, viability-distinct pair |
| ProxyDetachment | `strongly_anchored_not_weakly_anchored` | stronglyAnchored p → ¬weaklyAnchored p |
| LocalGlobalLoad | `has_load_iff_decoupled` | hasLocalGlobalLoad S ↔ LocalGlobalDecoupled S |
| ConstraintCapacity | `capacityDeficit_precludes_viability` | (viable → capacitySufficient) → capacityDeficit s → Pathology s |
| StabilityMargin | `margin_sufficient_has_compatibility` | StabilityMarginSufficient S → LocalGlobalCompatible S |

### Phase IV foothill theorems

| Tier | Module | Theorem | Statement |
|------|--------|---------|-----------|
| Foothill | SystemDiachronicCorrectionFailure | `system_diachronic_correction_failure` | (∃ s, ¬hasTraceFloor s) → ¬robustDiachronicCorrection S |
| Foothill | WeakAnchorUnsoundness | `weak_anchor_unsoundness` | weaklyAnchored p → ¬proxySound p |
| Foothill | DecouplingGeneratesPathology | `decoupling_generates_pathology` | LocalGlobalDecoupled → ∃ π, Path π ∧ ¬trajectoryViable π |
| Foothill | ConstraintDeficitBlocksViableContinuation | `constraint_deficit_blocks_viable_continuation` | (viability→capacity) ∧ (∃ deficit) → ¬robustViableContinuation |
| Foothill | CorrelatedFailureFragility | `correlated_failure_fragility` | ∃ s, commonModeFailure chs s → ¬robustAgainstCommonModeFailure chs |

### Phase V ridge theorems (complete)

| Tier | Module | Theorem | Status |
|------|--------|---------|--------|
| Ridge | ProxyDrift | `proxy_drift` | weak anchor + transition-connected pair → proxyGuidedPathDiverges |
| Ridge | LocalGlobalPathology | `local_global_pathology` | LocalGlobalDecoupled → ¬localAdmissibilityGuaranteesViableContinuation |
| Ridge | CorrelatedFailure | `correlated_failure` | ∃ s, commonModeFailure chs s → ¬independentCorrectionAvailable chs |
| Ridge | ConstraintDeficit | `constraint_deficit` | ∃ s, capacityDeficit s → ¬capacitySupportsViability S — ✅ |
| Ridge | CompositeBoundary | `composite_boundary` | BoundaryDefect → ¬robustViableContinuationSchema — ✅ |

### Phase VI summit theorems

| Tier | Module | Theorem | Statement |
|------|--------|---------|-----------|
| Summit | Robustness | `BoundaryDefect` | Named defect abstraction (4-fold disjunction) |
| Summit | Summit | `necessary_conditions_for_robust_viable_continuation` | Schema → ¬BoundaryDefect — ✅ |
| Summit | Summit | `general_viability_boundary` | BoundaryDefect → ¬Schema — ✅ |

## Sorry Status

**Target: zero sorry.** All foothill, ridge, and summit theorems are proved; no sorrys.

## Phase VII+: Frontier Principles

| Module | Theorems | Purpose |
|--------|----------|---------|
| Bridges.FrontierPrinciples | `agi_exhibits_decoupling`, `agi_exhibits_common_mode`, etc. | Maps frontier principles to defect witnesses in each bridge; proves each domain bridge exhibits LocalGlobalDecoupled and common-mode failure at pathological states |

Reference: Principles Paper Phase 2, FRONTIER_BRIDGE_TARGET_LEDGER.md

## File Structure

```
viable-continuation-lean/
├── lean-toolchain
├── lakefile.lean
├── README.md
├── MANIFEST.md
├── ARTIFACT.md
├── docs/
│   └── Overview.md
├── ViableContinuation.lean
└── ViableContinuation/
    ├── Core/
    │   ├── System.lean
    │   ├── Transitions.lean
    │   ├── Constraints.lean
    │   ├── Traces.lean
    │   ├── Channels.lean
    │   ├── Anchors.lean
    │   ├── LocalGlobal.lean
    │   └── Viability.lean
    ├── Measures/         (Phase III)
    ├── Theorems/          (Phase IV+)
    ├── Bridges/           (Phase VII)
    └── Examples/          (Phase IV+)
```

## Reproduction

```bash
cd ~/viable-continuation-lean
lake update
lake build
```

Expected: `Build completed successfully.`
