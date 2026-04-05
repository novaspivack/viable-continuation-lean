# viable-continuation-lean

**Repository:** https://github.com/novaspivack/viable-continuation-lean

Lean 4 formalization of the **Viable Continuation Under Constraint** framework—a general theory of stability, pathology, and collapse across reflexive and recursively constrained systems.

## Purpose

This library aims to prove a **general viability-boundary theorem family** from which domain claims (AGI, law, institutions, markets, biology, ecology, civilizations, etc.) follow as interpretation theorems and corollaries. The ambition is: one abstract theorem spine; many domain instantiations.

**Core principle:** No smuggled assumptions, no ad hoc axioms, maximum derivational continuity.

## Build

**Requirements:** Lean 4.29.0-rc3, Mathlib v4.29.0-rc3

```bash
cd viable-continuation-lean   # or ~/viable-continuation-lean if cloned separately
lake update
lake build
```

**Critical:** When used as a submodule under `NEMS_PAPERS/`, always build from a **short path** (e.g. clone to `~/viable-continuation-lean` or run from the submodule’s short canonical path), never from a long symlinked path, to avoid Mathlib path-length errors.

## Dependency Policy

- **Core** (`Core/`, `Measures/`, `Theorems/`): Depend only on Mathlib plus minimal internal definitions. Abstract and dependency-light.
- **Bridges** (`Bridges/`): May import `nems-lean` and `reflexive-closure-lean` for domain instantiations. Core remains independent.

## Structure

| Directory | Content |
|-----------|---------|
| `ViableContinuation/Core/` | System, Transitions, Constraints, Traces, Channels, Anchors, LocalGlobal, Viability |
| `ViableContinuation/Measures/` | Constraint capacity, transition pressure, trace capacity, etc. |
| `ViableContinuation/Theorems/` | Foothill, ridge, summit theorems |
| `ViableContinuation/Bridges/` | Domain schemas (AGI, Law, Bio, Civ, War, Pluralism, Ecology, Science, Physical) and FrontierPrinciples |

## Documentation

| Document | Description |
|----------|-------------|
| [MANIFEST.md](MANIFEST.md) | Artifact manifest, theorem catalog, sorry accounting |
| [ARTIFACT.md](ARTIFACT.md) | What the artifact proves, proof status |
| [docs/Overview.md](docs/Overview.md) | Project overview and scope |

## Related Repos

- **nems-lean** — NEMS framework spine, abstract-core libraries (SelfReference, Closure, SelectorStrength, etc.)
- **reflexive-closure-lean** — Reflexive closure arc (Papers 52–70)

## License

See [LICENSE](LICENSE) if present.
<!-- NOVA_ZPO_ZENODO_SOFTWARE_BEGIN -->
**Archival software (Zenodo):** https://doi.org/10.5281/zenodo.19429260
<!-- NOVA_ZPO_ZENODO_SOFTWARE_END -->
