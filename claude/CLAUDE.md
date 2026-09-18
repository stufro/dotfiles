# Global Claude Code Preferences

## Ruby/Rails Patterns

- Run `rubocop -A` to ensure you fix any styling issues.

### Predicate Methods
- Use Rails predicate methods (e.g., `rule.approve?`, `rule.decline?`) instead of string comparisons (`rule.action == 'approve'`)
- In tests, prefer using assert_predicate(company, :atm_enabled?)

### Stimulus Controllers
- Always use targets properly - don't declare targets and then use `querySelector`
- Example: Use `this.buttonTargets.forEach()` instead of `this.element.querySelectorAll('.btn')`

### I18n
- When using `I18n.t()` with symbols that are just variables (not interpolated strings), pass the symbol directly: `I18n.t(variable)` not `I18n.t(:"#{variable}")`
- Use lambdas for dynamic headings: `heading: ->(obj) { I18n.t(:"dynamic_#{obj.label}") }`

## Testing

### Running Specific Tests
- Use line numbers to run specific tests: `bundle exec rails test test/file_test.rb:50`

### System Tests with Hidden Elements
- When radio buttons are hidden in custom UI (like button groups), tests fail with `choose()`
- Use `find("label[for='radio_id']").click` instead
- System test login can be flaky - run tests in isolation if they fail intermittently
