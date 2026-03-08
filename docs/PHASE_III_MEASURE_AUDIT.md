# Phase III Measure Audit

**Date:** March 8, 2026  
**Status:** Complete — ready for advisor review before Phase IV

---

## 1. Primitive vs Derived

### 1.1 Primitives (class/structural, require instances)

| Measure | File | Primitive | Role |
|---------|------|-----------|------|
| Transition pressure | `TransitionPressure.lean` | `HasTransitionPressure` | Assigns pressure level per state; preorder on levels |
| Constraint capacity | `ConstraintCapacity.lean` | `HasConstraintCapacity` | Assigns capacity level per state; required floor |
| Channels (from Core) | — | `HasChannels` | Needed for correlation measures |

### 1.2 Derived (defined from ontology + primitives)

| Measure | Definition | From |
|---------|------------|------|
| `pressureBoundedBy`, `pressureDominates`, `highPressure` | Preorder on `PressureLevel` | `HasTransitionPressure` |
| `capacityDeficit`, `capacitySufficient` | `effectiveCapacity s` vs `requiredFloor` | `HasConstraintCapacity` |
| `TraceSufficient`, `hasTraceFloor`, `diachronicCorrectionFails` | `recordIndistinguishable` + `Viable` | System, Viability (no new primitive) |
| `weaklyIndependent`, `stronglyDecorrelated`, `correlatedPair`, `commonModeFailure` | `HasChannels.fails` | `HasChannels` |
| `proxyIndistinguishable`, `viabilityDistinct`, `detachmentSet`, `fidelityLe`, `stronglyAnchored` | `proxySaysViable`, `Viable`, `AnchorFidelity` | Core Anchors |
| `badTransition`, `hasLocalGlobalLoad`, `decouplingSet` | `transition`, `Viable`, `Pathology` | Transitions, Viability |
| `StabilityMarginSufficient` | Conjunction of `capacitySufficient`, `TraceSufficient`, `LocalGlobalCompatible S` | All measure modules |

### 1.3 Summary

- **3 primitive measure structures:** `HasTransitionPressure`, `HasConstraintCapacity` (and `HasChannels` from Core).
- All other measures are derived from the ontology and these primitives.
- **Rule D satisfied:** No extra primitives beyond what theorems need.

---

## 2. Scalar vs Preorder vs Tuple

### 2.1 Framework choice

The framework is **preorder-based**, not scalar-based.

| Decision | Rationale |
|----------|-----------|
| **Preorder over scalar** | “Pressure,” “capacity,” “load” are compared, not measured by a single number. Preorders support “at least as much,” “dominates,” “deficit” without committing to a metric. |
| **Tuple for composite** | `StabilityMarginSufficient` is a conjunction of conditions, not a fake grand scalar. Each component is a structural predicate. |
| **Relational where possible** | `weaklyIndependent`, `correlatedPair`, `proxyIndistinguishable` are relations, not numeric scores. |

### 2.2 Why this choice is right

1. **Theorem-usable:** Preorders support `capacityDeficit s → Pathology s` and similar implications without numeric assumptions.
2. **Minimally committal:** No hidden choice of units, scales, or aggregation.
3. **Interpretation-friendly:** Domains can add numeric instances later (e.g., transition count as pressure) without changing the abstract layer.
4. **Advisor Rule A:** Preference for relational/order-theoretic measures is satisfied.

---

## 3. Measure-by-Measure Summary

### 3.1 TransitionPressure.lean

- **Measures:** When transitions are “too abundant” or “too unconstrained” relative to control.
- **Meaningful comparisons:** `pressureBoundedBy s L`, `pressureDominates s s'`, `highPressure L s`.
- **Theorem target:** Pressure exceeds capacity ⇒ viable continuation fails.
- **Lemma:** `pressureMonotoneInTransitions` — compatibility with “more transitions ⇒ higher pressure.”

### 3.2 ConstraintCapacity.lean

- **Measures:** Effective capacity at a state vs a required floor (coverage / admissibility-bound).
- **Meaningful comparisons:** `capacityDeficit s`, `capacitySufficient s`.
- **Theorem target:** Deficit ⇒ pathology (when capacity is necessary for viability).
- **Lemma:** `capacityDeficit_precludes_viability` — deficit ⇒ pathology under the viability–capacity link.

### 3.3 TraceCapacity.lean

- **Measures:** Whether records at a state determine viability (trace sufficiency / floor).
- **Meaningful comparisons:** `TraceSufficient s`, `hasTraceFloor s`, `diachronicCorrectionFails s`.
- **Theorem target:** ¬TraceSufficient s ⇒ diachronic correction fails.
- **Lemmas:** `not_trace_sufficient_implies_diachronic_correction_fails`, `not_hasTraceFloor_implies_diachronic_correction_fails`.

### 3.4 Correlation.lean

- **Measures:** Independence hierarchy for channels — weakly independent, strongly decorrelated, correlated pair, common-mode failure.
- **Meaningful comparisons:** `weaklyIndependent ch₁ ch₂`, `stronglyDecorrelated ch₁ ch₂`, `correlatedPair ch₁ ch₂`.
- **Theorem target:** Correlated channels reduce effective redundancy; loss of independence ⇒ fragility.
- **Lemma:** `correlated_pair_not_weakly_independent` — correlated pair implies not weakly independent.

### 3.5 ProxyDetachment.lean

- **Measures:** Anchor fidelity, proxy detachment, weak vs strong anchoring.
- **Meaningful comparisons:** `fidelityLe p₁ p₂`, `weaklyAnchored p`, `stronglyAnchored p`.
- **Theorem target:** Proxy-indistinguishable but viability-distinct states exist (weak anchoring); strong anchoring blocks certain pathologies.
- **Lemmas:** `weakly_anchored_has_indistinguishable_distinct_pair`, `strongly_anchored_not_weakly_anchored`.

### 3.6 LocalGlobalLoad.lean

- **Measures:** Load of “bad” transitions (viable → pathological).
- **Meaningful comparisons:** `hasLocalGlobalLoad` (nonempty load) vs empty.
- **Theorem target:** Local–global decoupling / load ⇒ deficit theorems.
- **Lemma:** `has_load_iff_decoupled` — hasLocalGlobalLoad ↔ LocalGlobalDecoupled S.

### 3.7 StabilityMargin.lean

- **Measures:** Composite sufficiency (constraint, trace, local–global) — only if earned.
- **Meaningful comparisons:** `StabilityMarginSufficient S` (conjunction of components).
- **Theorem target:** Margin sufficient ⇒ local–global compatible.
- **Lemma:** `margin_sufficient_has_compatibility` — by definition, margin implies compatibility.

---

## 4. Foothill Preview — Precise Target Statements

Below are the intended theorem statements for Phase IV, expressed using the measure layer. **No proofs yet** — these are the exact statements to prove.

### 4.1 Trace floor

**Target:**  
For any state \(s\),
\[
\neg \mathsf{hasTraceFloor}\,s \implies \mathsf{diachronicCorrectionFails}\,s
\]

**Status:** Proved as `not_hasTraceFloor_implies_diachronic_correction_fails` in `TraceCapacity.lean`.

---

### 4.2 Correlated failure

**Target:**  
For channels \(ch_1\), \(ch_2\),
\[
\mathsf{correlatedPair}\,ch_1\,ch_2 \implies \neg \mathsf{weaklyIndependent}\,ch_1\,ch_2
\]

**Status:** Proved as `correlated_pair_not_weakly_independent` in `Correlation.lean`.

**Stronger target (Phase IV):**  
When channels are correlated, common-mode failure implies system fragility (or similar deficit). Structure is in place; exact statement TBD after first proofs.

---

### 4.3 Weak anchor / proxy indistinguishability

**Target (existence):**  
For proxy \(p\),
\[
\mathsf{weaklyAnchored}\,p \implies \exists s\,s',\ \mathsf{proxyIndistinguishable}\,p\,s\,s' \wedge \mathsf{viabilityDistinct}\,s\,s'
\]

**Status:** Proved as `weakly_anchored_has_indistinguishable_distinct_pair` in `ProxyDetachment.lean`.

**Target (strong vs weak):**  
\[
\mathsf{stronglyAnchored}\,p \implies \neg \mathsf{weaklyAnchored}\,p
\]

**Status:** Proved as `strongly_anchored_not_weakly_anchored` in `ProxyDetachment.lean`.

---

### 4.4 Local–global decoupling

**Target:**  
\[
\mathsf{hasLocalGlobalLoad}\,S \iff \mathsf{LocalGlobalDecoupled}\,S
\]

**Status:** Proved as `has_load_iff_decoupled` in `LocalGlobalLoad.lean`.

**Stronger target (Phase IV):**  
When load exists, viable continuation fails (or similar). Requires connecting load to viability.

---

### 4.5 Constraint deficit

**Target:**  
Under the assumption that viability implies sufficient capacity,
\[
\forall s,\ \mathsf{capacityDeficit}\,s \implies \mathsf{Pathology}\,S\,s
\]

**Status:** Proved as `capacityDeficit_precludes_viability` in `ConstraintCapacity.lean`.

---

## 5. Caution Flags Addressed

| Flag | Resolution |
|------|------------|
| **Constraint capacity becoming empty** | Avoided: `capacityDeficit` and `capacitySufficient` are defined via preorder; `capacityDeficit_precludes_viability` gives a concrete theorem link. |
| **Correlated failure too binary** | Addressed: Hierarchy `weaklyIndependent` ⊂ `stronglyDecorrelated`; `correlatedPair` and `commonModeFailure` are distinct. Further gradations can be added without changing the core. |
| **Physical regimes distorting abstractions** | Avoided: Measures stay abstract; no domain-specific structure in the core. A separate interpretation layer can handle physical regimes. |

---

## 6. Rule Compliance

| Rule | Status |
|------|--------|
| **A.** Prefer relational/order-theoretic over numeric | ✓ Preorders throughout; no scalar gauges. |
| **B.** Every measure answers: what object, what comparisons, what theorems | ✓ Documented in §3. |
| **C.** Each measure file has ≥1 lemma | ✓ All measure files have lemmas. |
| **D.** No extra primitives | ✓ Only `HasTransitionPressure`, `HasConstraintCapacity` added; rest derived. |
| **E.** Document in Spine.md | ✓ See updated `docs/Spine.md`. |

---

## 7. Next Steps

1. ~~Advisor review~~ — **Phase III approved.** Phase IV approved with revised mandate.
2. **Phase IV foothill theorems** — prove **system-level** theorems, not restatements of Phase III lemmas. See `docs/Spine.md` §3.2 and `VIABLE_CONTINUATION_PROGRAM.md` Phase IV.
3. Make foothills talk to each other — that is where the ridge begins.
