# Nobetci Eczane — NosyAPI Integration

## API Base URL
```
https://www.nosyapi.com/apiv2/service/pharmacies-on-duty
```

## Authentication
Pass API key via any of:
- Header: `Authorization: Bearer <key>`
- Header: `X-NSYP: <key>`
- Query param: `?apiKey=<key>`

---

## Endpoints

### 1. GET /cities
Get all cities with slug values.
**Cost:** 0 credits

```
GET /pharmacies-on-duty/cities
```

### 2. GET /count-cities
Pharmacy count per city/district. **Cost:** 1 credit

```
GET /pharmacies-on-duty/count-cities
GET /pharmacies-on-duty/count-cities?city=ankara
```

### 3. GET /status
Last update timestamp. **Cost:** 0 credits

### 4. GET /
List duty pharmacies by city/district. **Cost:** 1 credit

| Param | Value | Description |
|-------|-------|-------------|
| city | ankara | city slug (from /cities) |
| district | kadikoy | district slug |
| detailsID | 1234 | lookup specific pharmacy by ID |

```
GET /pharmacies-on-duty?city=istanbul
GET /pharmacies-on-duty?city=istanbul&district=kadikoy
```

**Important:** city and district must use **slug values** (lowercase, no spaces)
- "İstanbul" → `istanbul`
- "Kadıköy" → `kadikoy`
- "Ankara" → `ankara`

### 5. GET /locations
Nearest 20 pharmacies by lat/long. **Cost:** 1 credit

| Param | Type | Description |
|-------|------|-------------|
| latitude | double | Latitude |
| longitude | double | Longitude |

```
GET /pharmacies-on-duty/locations?latitude=38.432561&longitude=27.143503
```

Returns 20 closest pharmacies with **distanceMt/distanceKm/distanceMil** fields.

### 6. GET /all
All pharmacies in Turkey + KKTC. **Cost:** 81 credits (expensive — don't call frequently)

---

## Data Models

### Pharmacy
```swift
struct Pharmacy: Identifiable, Codable {
    let id: String           // pharmacyID
    let name: String         // pharmacyName
    let address: String
    let phone: String        // e.g. "0(232)463-40-86"
    let phone2: String?
    let latitude: Double
    let longitude: Double
    let city: String         // Full name e.g. "İstanbul"
    let district: String     // e.g. "Konak"
    let town: String?
    let directions: String?
    let pharmacyDutyStart: String?  // "2024-01-21 09:30:00"
    let pharmacyDutyEnd: String?
    var distance: Double?     // Computed (km)
}
```

### API Response
```json
{
    "status": "success",
    "message": "ok",
    "messageTR": "ok",
    "systemTime": 1705870028,
    "endpoint": "pharmacies-on-duty",
    "rowCount": 1,
    "creditUsed": 1,
    "data": [ /* Pharmacy[] */ ]
}
```

---

## Notes
- Slugs: lowercase, Turkish characters converted (İ→i, ı→i, ş→s, ğ→g, ü→u, ö→o, ç→c)
- Phone numbers may be masked (e.g. "0(232)***-**-**") — masked numbers won't work for calling
- API key: (Removed for security - see Secrets.plist.example)
- Credit cost: 1 per /pharmacies-on-duty call, 0 for /cities and /status
- 81 credits per call for /all — use sparingly