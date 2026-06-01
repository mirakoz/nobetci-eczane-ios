## 2026-05-22 - Hardcoded API Credentials in Source Code
**Vulnerability:** A live API key for NosyAPI was hardcoded in `Constants.swift` and also present in a reference markdown file.
**Learning:** Hardcoding secrets is a common but high-risk practice that exposes the application to unauthorized use and credential leakage.
**Prevention:** Always use dynamic secret loading from non-committed files (like `Secrets.plist`) and provide templates (`.example` files) for local development. Use `.gitignore` to prevent accidental commits of sensitive files.
