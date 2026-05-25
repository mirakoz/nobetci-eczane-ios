## 2026-05-25 - Hardcoded API Key and Manual URL Construction
**Vulnerability:** A sensitive API key for NosyAPI was hardcoded in `Constants.swift`. Additionally, API URLs were being constructed using manual string interpolation, which is prone to encoding errors and potential injection issues.
**Learning:** Hardcoding secrets in source code is a common but critical security risk, as they can be accidentally committed to version control. Manual URL construction is less secure and more error-prone than using specialized system components.
**Prevention:** Use a `.plist` file (excluded from Git) to manage secrets at runtime. Use `URLComponents` and `URLQueryItem` for all API request constructions to ensure proper encoding and security.
