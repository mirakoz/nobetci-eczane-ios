## 2025-01-24 - API Key Exposure and URL Injection
**Vulnerability:** Hardcoded API key in source code and documentation. Use of string interpolation for URL construction.
**Learning:** Hardcoding keys simplifies development but risks credential leakage. String interpolation for URLs can lead to malformed requests or injection if parameters aren't properly escaped.
**Prevention:** Use a `.gitignore`ed `Secrets.plist` for local development and CI/CD environment variables for production. Always use `URLComponents` and `URLQueryItem` for building URLs.
