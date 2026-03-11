# Errors Log

Captures command failures, exceptions, unexpected behavior, and integration issues.

## Format

- **ID:** ERR-YYYYMMDD-NNN
- **Title:** Brief error description
- **Category:** `command_failed` | `api_error` | `timeout` | `unexpected_output` | `authentication` | `permission_denied`
- **Priority:** `critical` | `high` | `medium` | `low`
- **Status:** `pending` | `investigating` | `resolved` | `wontfix`
- **Area:** (e.g., `git`, `network`, `api`, `build`, `deploy`)
- **Pattern-Key:** (for recurring issues)
- **Recurrence-Count:**
- **First-Seen:**
- **Last-Seen:**
- **See Also:**
- **Description:** What command was run, what happened, error output, context
- ** attempted fix:** What was tried to resolve it
- **Root cause:** (once identified)
- **Solution:** (once fixed)

---

## Entries

*None yet.*