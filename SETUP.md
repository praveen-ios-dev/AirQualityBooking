# Setup Guide & Architecture Decision Records

## Quick Start

### 1. Clone & Open

```bash
git clone <repo>
cd AirQualityBooking
open AirQualityBooking.xcodeproj
```

### 2. Install Dependencies (SPM)

Xcode resolves packages automatically via `Package.swift`:
- **Alamofire** 5.9+ — networking
- **Factory** 2.3+ — dependency injection

### 3. API Keys

Open `Config.xcconfig` and replace:

```swift
// AirQualityAPIService
AQI_TOKEN = 
// Get a free token at: https://aqicn.org/data-platform/token/
```

### 4. Toggle Mocks

In `Container+Extension.swift`:

```swift
enum AppConfig {
    static var useMocks: Bool = true  // ← This handle reading from mock
}
```

In all *RepositoryImpl init by default it is set as false except BookRepositoryImpl because that data we are always reading from Mock
- This is also one of the reason to keep it in init.

When `useMocks in *RepositoryImpl = true`, all network calls return deterministic mock data
with a small simulated delay. **Business logic is untouched.**

### 5. Run Tests

```bash
xcodebuild test \
  -scheme AirQualityBooking \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

---

## Architecture Decision Records

### ADR-1: MVVMC over TCA

**Decision**: MVVMC (ViewModel + Coordinator) instead of The Composable Architecture.

**Rationale**:
- TCA adds ~200KB binary overhead and a steep onboarding curve.
- The assignment scope (5 screens, simple flows) doesn't benefit from TCA's
  global store or effect system.
- MVVMC gives unidirectional flow via `Intent` enums while remaining
  approachable and Swift-idiomatic.

**Trade-off**: No built-in time-travel debugging. Mitigated by keeping
ViewModels pure and fully unit-testable.

---

### ADR-2: FactoryKit over Swinject / manual DI

**Decision**: FactoryKit for dependency injection.

**Rationale**:
- Compile-time safe (no string keys, no force casts).
- Minimal boilerplate — `@Injected` property wrapper reads naturally.
- Supports `.singleton`, `.shared`, `.unique` scopes out of the box.
- Trivial to swap real ↔ mock: one `AppConfig.useMocks` bool.

---

### ADR-3: Swift Actor for CoordinateCache

**Decision**: `CoordinateCache` is a Swift `actor`.

**Rationale**:
- Map camera updates and network callbacks run on different threads.
- An `actor` provides automatic mutual exclusion without `DispatchQueue` or
  locks, and the Swift compiler enforces await at every access point.
- The cache is shared across multiple use cases — actor isolation prevents
  races with zero explicit synchronisation code.

---

### ADR-4: Coordinate Precision Rule (3rd decimal)

**Decision**: Cache key = `round(lat * 1000) / 1000`.

**Rationale**: The assignment specification:
> "If both latitude and longitude match up to the third decimal place,
>  treat them as the same location."

Example:
```
37.5642 → 37.564   ✓ same bucket
37.5645 → 37.565   ✗ different bucket (rounds up at .5)
```

This is implemented in `Coordinate.cacheKey`.

---

### ADR-5: Mock Isolation Pattern

**Decision**: Mocks implement the same `*NetworkService` protocols as real
services. The swap is at container level only.

```
View → ViewModel → UseCase → Repository → NetworkService (real OR mock)
                                                    ↑
                                            AppConfig.useMocks
```

**Benefit**: Business logic (UseCases, Repositories, ViewModels) is
**never aware** of mock vs. real. Tests inject mock repos directly,
bypassing the network layer entirely.

---

### ADR-6: Unidirectional Data Flow via Intent Enums

Each ViewModel exposes a single `handle(_ intent: XIntent)` entry point.

```swift
// View
viewModel.handle(.setLocationTapped)

// ViewModel
func handle(_ intent: MapIntent) {
    switch intent {
    case .setLocationTapped: Task { await handleSetLocation() }
    // ...
    }
}
```

**Benefits**:
- All state mutations are traceable to a single switch statement.
- Easy to log/replay intents for debugging.
- No scattered method calls; views remain thin.

---

### ADR-7: NavigationStack + Coordinator

**Decision**: `AppCoordinator` owns a `NavigationPath` and a typed `Route` enum.
Views call coordinator methods; the coordinator appends to the path.

**Why not SwiftUI sheet/fullScreenCover everywhere?**
- The 5-screen flow is linear with one back-stack reset (`resetToRoot`).
- `NavigationStack` handles the back button, pop gestures, and large-title
  transitions for free.
- `resetToRoot` simply replaces the path with an empty one — no manual
  dismiss chain needed.

---

## Screen Navigation Map

```
MapView (Screen 1)
  ├─ [Label A/B tapped, pin set]   → LocationDetailView (Screen 2)
  │       └─ [Save/Skip]           → back to MapView
  ├─ [Label A/B tapped, no pin]   → CachedLocationsView (Screen 5)
  │       └─ [Select location]     → back to MapView
  ├─ [Book tapped]                → BookingView (Screen 3)
  │       ├─ [View History]       → HistoryView (Screen 4)
  │       │       └─ [Tap record] → MapView (reset + preload)
  │       └─ [Back to Home]       → MapView (reset)
  └─ [Back from any screen]       → MapView (dismiss)
```
