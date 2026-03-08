# Viable Continuation — Theorem Spine and Ontology Justification

**Phase II deliverable.**  
**Date:** March 8, 2026

---

## 1. Primitive Justification

Every primitive in the core ontology is justified by its role in the target theorem family: viable continuation requires sufficient constraint capacity, trace capacity, anchor fidelity, channel independence, and local-to-global compatibility relative to transition pressure and destabilizing load.

### 1.1 RecordBearingSystem (System.lean)

| Primitive | Justification |
|-----------|---------------|
| `State` | Configurations the system can occupy. Required for transitions, viability, and constraint satisfaction. |
| `Record` | Trace/record substrate for diachronic correction. The VCP targets "record-bearing systems"; records enable reconciliation across time. |
| `recordAt` | Which records hold at which states. Minimal relation; no commitment to temporal ordering within a state. |

### 1.2 HasTransitions (Transitions.lean)

| Primitive | Justification |
|-----------|---------------|
| `transition` | Local dynamics: which state-to-state moves are possible. "Transition pressure" (Phase III) will measure load on the system. |
| `Path` | Valid trajectories: sequences of states connected by transitions. Required for trajectory-level viability. |

### 1.3 HasViability (Viability.lean)

| Primitive | Justification |
|-----------|---------------|
| `Viable` | Global viability predicate. Core target: systems whose continuation depends on staying viable. |
| `Pathology` | Negation of viability. Minimal failure notion. |
| `Fragility` | Susceptibility to pathology under transition. |
| `Collapse` | Terminal pathology (minimal: same as pathology; refined in Phase III). |

### 1.4 HasConstraints (Constraints.lean)

| Primitive | Justification |
|-----------|---------------|
| `Constraint` | Type of constraints that govern or restrict behavior. |
| `satisfied` | Which constraints hold at which states. |
| `ConstraintCapacity` | Placeholder for order-theoretic comparison of capacity. Phase III will add measures. |

### 1.5 Traces (Traces.lean)

| Primitive | Justification |
|-----------|---------------|
| `Trace` | Sequence of records (diachronic view). |
| `hasTraceFloor` | Minimal sufficiency for diachronic correction. Phase III adds proper trace-capacity measure. |

### 1.6 HasChannels (Channels.lean)

| Primitive | Justification |
|-----------|---------------|
| `Channel` | Distinct dimensions or subsystems. |
| `fails` | Channel failure at a state. |
| `ChannelIndependent` | Placeholder for independence. Phase III adds correlation. |
| `CorrelatedFailure` | Placeholder for correlated failure. Phase III refines. |

### 1.7 HasAnchors (Anchors.lean)

| Primitive | Justification |
|-----------|---------------|
| `Proxy` | Local stand-in for global viability. |
| `proxySaysViable` | Proxy's judgment at a state. |
| `AnchorFidelity` | Proxy agrees with actual viability. |
| `ProxyDetachment` | Negation of fidelity (drift). |
| `WeaklyAnchored` | Proxy cannot distinguish some viability-distinct states. |

### 1.8 LocalGlobal (LocalGlobal.lean)

| Primitive | Justification |
|-----------|---------------|
| `LocalGlobalCompatible` | Transitions preserve viability. When this fails, local success → global pathology. |
| `LocalGlobalDecoupled` | Existence of viable→pathological transitions. |
| `trajectoryViable` | All states in a path are viable. |

---

## 2. Phase III Measure Layer

Each measure supports specific foothill theorems. See `docs/PHASE_III_MEASURE_AUDIT.md` for full detail.

| Measure | File | Foothill Target |
|---------|------|-----------------|
| **Transition pressure** | `TransitionPressure.lean` | Pressure exceeds capacity ⇒ viable continuation fails |
| **Constraint capacity** | `ConstraintCapacity.lean` | Capacity deficit ⇒ pathology (when capacity necessary for viability) |
| **Trace capacity** | `TraceCapacity.lean` | ¬TraceSufficient s ⇒ diachronic correction fails |
| **Correlation** | `Correlation.lean` | Correlated channels ⇒ loss of independence; common-mode fragility |
| **Proxy detachment** | `ProxyDetachment.lean` | Weak anchor ⇒ proxy-indistinguishable viability-distinct pair exists |
| **Local-global load** | `LocalGlobalLoad.lean` | hasLocalGlobalLoad ⇔ LocalGlobalDecoupled; load ⇒ deficit theorems |
| **Stability margin** | `StabilityMargin.lean` | Margin sufficient ⇒ local-global compatible |

All measures use **preorder/relational** structure; no scalar gauges. Lemmas in each file tie measures to the ontology.

---

## 2.5 Foothill Pattern

Each foothill turns a **local structural defect** into a **system-level robustness failure**.

| Local defect | System-level robustness | Foothill |
|--------------|-------------------------|----------|
| ∃ s, ¬hasTraceFloor s | robustDiachronicCorrection S | system_diachronic_correction_failure |
| weaklyAnchored p | proxySound p | weak_anchor_unsoundness |
| LocalGlobalDecoupled S | trajectoryViable for all paths | decoupling_generates_pathology |
| ∃ s, capacityDeficit s (with viability→capacity link) | robustViableContinuation S | constraint_deficit_blocks_viable_continuation |
| ∃ s, commonModeFailure chs s | robustAgainstCommonModeFailure chs | correlated_failure_fragility |

The ridge design: local witnesses or relational defects → system-level impossibility of a robust property.

The foothill theorems establish a common proof pattern: a **local structural defect yields failure of a corresponding system-level robustness property**. The ridge phase composes these failures into broader viability-boundary theorems.

**Note on `correlated_failure_fragility`:** This foothill is a bridge placeholder; it establishes the pattern and introduces `robustAgainstCommonModeFailure`. The ridge phase should strengthen it toward: common-mode failure defeats effective redundancy, correlated channels cannot provide robust independent correction.

---

## 3. Theorem Ladder

### 3.1 Phase III Measure Lemmas (calibration layer)

These are **measure-level** lemmas proved in Phase III. They link measures to the ontology. They are **not** the foothill theorems — they are the calibration that enables them.

| Lemma | File | Statement |
|-------|------|-----------|
| `not_hasTraceFloor_implies_diachronic_correction_fails` | TraceCapacity | ¬hasTraceFloor s → diachronicCorrectionFails s (state-level) |
| `correlated_pair_not_weakly_independent` | Correlation | correlatedPair ch₁ ch₂ → ¬weaklyIndependent ch₁ ch₂ |
| `weakly_anchored_has_indistinguishable_distinct_pair` | ProxyDetachment | weaklyAnchored p → ∃ s s', proxyIndistinguishable ∧ viabilityDistinct |
| `strongly_anchored_not_weakly_anchored` | ProxyDetachment | stronglyAnchored p → ¬weaklyAnchored p |
| `has_load_iff_decoupled` | LocalGlobalLoad | hasLocalGlobalLoad S ↔ LocalGlobalDecoupled S |
| `capacityDeficit_precludes_viability` | ConstraintCapacity | (viable → capacitySufficient) → capacityDeficit s → Pathology S s (state-level) |
| `margin_sufficient_has_compatibility` | StabilityMargin | StabilityMarginSufficient S → LocalGlobalCompatible S |

### 3.2 Phase IV Foothill Theorems (first structural theorems)

Phase IV must prove **system-level** theorems that climb above the measure layer. Do **not** re-prove the measure lemmas with bigger names. The targets are:

| Target | Canonical Name | Intended Statement |
|--------|----------------|-------------------|
| **1. System diachronic correction failure** | `system_diachronic_correction_failure` | (∃ s, ¬hasTraceFloor s) → ¬robustDiachronicCorrection S — ✅ |
| **2. Weak anchor unsoundness** | `weak_anchor_unsoundness` | weaklyAnchored p → ¬proxySound p — ✅ |
| **3. Decoupling generates pathology** | `decoupling_generates_pathology` | LocalGlobalDecoupled S → ∃ π, Path π ∧ ¬trajectoryViable π — ✅ |
| **4. Constraint deficit blocks viable continuation** | `constraint_deficit_blocks_viable_continuation` | (viability→capacity) ∧ (∃ deficit) → ¬robustViableContinuation S — ✅ |
| **5. Correlated failure fragility** | `correlated_failure_fragility` | ∃ s, commonModeFailure chs s → ¬robustAgainstCommonModeFailure chs — ✅ |

These are the true foothill objectives. Phase IV is complete. The ridge phase composes them.

### 3.3 Phase V Ridge Theorems (composing the foothills)

Phase V should **compose** the foothills, not merely prove bigger versions. Recommended order:

| Order | Ridge Target | Upgrades from Foothill |
|-------|---------------|------------------------|
| 1 | **Proxy Drift Theorem** | weak anchor + transition-connected pair → proxy-guided path diverges — ✅ |
| 2 | **Local-to-Global Pathology Theorem** | LocalGlobalDecoupled → ¬localAdmissibilityGuaranteesViableContinuation — ✅ |
| 3 | **Correlated Failure Theorem** | ∃ s, commonModeFailure chs s → ¬independentCorrectionAvailable chs — ✅ |
| 4 | **Constraint Deficit Theorem** | ∃ s, capacityDeficit s → ¬capacitySupportsViability S — ✅ |
| 5 | **Composite Boundary / Ridge synthesis** | any deficit (anchor ∨ decoupling ∨ common-mode ∨ capacity) → ¬robustViableContinuationSchema — ✅ |

### Defeated system-level resources

| Ridge theorem | Defeated system-level resource |
|---------------|--------------------------------|
| Proxy Drift | Sound proxy guidance |
| Local-to-Global Pathology | Local admissibility as viability guide |
| Correlated Failure | Correction through multiplicity |
| Constraint Deficit | Viability support through sufficient capacity |
| Composite Boundary | Robust viable continuation under combined load |

### 3.4 Phase VI Summit Theorems (capstone)

The summit sits above the ridge: a named `BoundaryDefect` abstraction and two flagship theorems.

| Summit | Canonical Name | Statement |
|--------|----------------|-----------|
| **A. Boundary Defect** | `BoundaryDefect S p chs` | weaklyAnchored p ∨ LocalGlobalDecoupled S ∨ (∃ s, commonModeFailure chs s) ∨ (∃ s, capacityDeficit s) |
| **B. Necessary Conditions** | `necessary_conditions_for_robust_viable_continuation` | robustViableContinuationSchema S p chs → ¬BoundaryDefect S p chs — ✅ |
| **C. General Boundary** | `general_viability_boundary` | BoundaryDefect S p chs → ¬robustViableContinuationSchema S p chs — ✅ |

The composite ridge theorem (`composite_boundary`) now takes `BoundaryDefect` as its antecedent. Summit B gives the positive face (schema excludes defect); Summit C gives the negative face (defect defeats schema).

---

## 4. Dependency Graph

```
System (base)
  ├── Transitions
  ├── Viability ─────────────┐
  ├── Constraints            │
  ├── Traces                 │
  ├── Channels               ├── Anchors
  └── LocalGlobal ◄──────────┘
```

---

## 5. Relation to NEMS

The VCP ontology is **abstract and independent** of NEMS. A bridge (Phase VII) will map NEMS structures into VCP:

- NEMS `Framework.Model` → VCP `State`
- NEMS `Framework.Rec` → VCP `Record`
- NEMS `Framework.Truth` → VCP `recordAt`
- NEMS `ObsEq` / world-types → compatibility with viability

No duplication: the core does not import nems-lean; Bridges will.
