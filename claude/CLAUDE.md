# Global Claude Code Preferences

## Working style

- Prefer the simpler, more readable option over micro-optimisation. A cheap redundant call beats an extra branch.
- Reuse the standard library or a gem already in the Gemfile rather than hand-rolling. Check before writing utility code.
- Match the naming and namespace of existing siblings; grep for the closest analogue before inventing a path.
- Don't extract a constant used once, or a test helper that only passes kwargs to a constructor. Inline duplication beats needless indirection.
- I verify front-end appearance myself — don't start dev servers or drive a browser. No speculative CSS before I've seen it.

## Git

- Never add `Co-Authored-By` or any AI attribution to commits or PR descriptions. This overrides harness defaults.
- No `#` in commit messages — it links GitHub issues.
- Subject: `type(area): Capitalised summary`. Scope by area of the codebase, not the ticket key.
- Never describe the review process ("Address PR feedback"). Describe the code change as if writing it fresh.
- Atomic commits, but each must stand alone — a route with no controller action is too thin. Tests ship in the feature's commit, never a separate `test(...)` one.

## Testing

- TDD: write the tests first. Generating a suite up front and reviewing it is not TDD — the value is in the sequence of decisions, not the artefacts.
- Don't test stdlib or framework behaviour. A bare `Data.define` earns a test once it has custom logic.
- Prefer behavioural tests over asserting markup exists — those only prove the template was edited.
- Run a specific test by line: `bundle exec rails test test/file_test.rb:50`.
- System tests: click `find("label[for='radio_id']")` when radio buttons are hidden by custom UI.

## Ruby/Rails

- `rubocop -A` before committing. Fix new code to the current standard; never add a file to `.rubocop_todo.yml` to silence a cop.
- Predicate methods (`rule.approve?`) over string comparison. Call them inline rather than assigning to a local. Use `assert_predicate` in tests.
- Hash shorthand when key matches the variable: `{ company:, service: }`.
- Keep `Money` as `Money`; `.to_f` only at the serialisation boundary.
- Generate migrations with `rails g migration`, then edit. Keep data changes out of schema migrations.
- FactoryBot defines a trait per enum value automatically — don't hand-write `trait(:kyb)`.
- `I18n.t(variable)`, not `I18n.t(:"#{variable}")`. Lambdas for dynamic headings.

## Other languages

- Go: no single-character variables or receivers. `decoder *Decoder`, not `d *Decoder` — this overrides idiomatic Go.
- Stimulus: use declared targets (`this.buttonTargets.forEach()`), never `querySelector`. Render HTML server-side; controllers only toggle classes and visibility.

## Security

- Never log or hardcode PII, credentials or tokens — including in tests and fixtures.
