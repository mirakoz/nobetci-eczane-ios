## 2026-05-30 - Hardcoded API Key Exposure
**Vulnerability:** A live production API key for NosyAPI was hardcoded in `Constants.swift`, exposing it to anyone with access to the source code.
**Learning:** Even when security remediation is mentioned in project documentation or memory, regression can occur if the source code itself is not synchronized or if build/configuration templates are missing. A robust loading mechanism must be coupled with a `.gitignore` and an explicit template (`.plist.example`) to prevent accidental re-introduction.
**Prevention:** Always use dynamic secret loading from non-committed files (like `Secrets.plist`). Use `.gitignore` to explicitly block these files and provide `.example` templates for other developers.
