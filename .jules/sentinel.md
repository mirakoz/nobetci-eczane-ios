## 2024-05-29 - Hardcoded API Key in Constants
**Vulnerability:** The `nosyAPIKey` was hardcoded directly in `Constants.swift`, exposing it in the source code.
**Learning:** Hardcoding secrets in source code is a common but critical security risk. It makes secrets easily discoverable in version control history.
**Prevention:** Use a `.plist` file (or environment variables) to store secrets and ensure that file is excluded from version control using `.gitignore`. Provide an example template for other developers.
