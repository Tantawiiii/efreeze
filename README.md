## efreeze

Modern Flutter e‑commerce app with clean layering, `Cubit` state management, and a service-driven API integration using `Dio`. The app includes onboarding, authentication, home catalog with categories/offers/search, cart, checkout, favorites, reviews, and settings (profile update, contact us).

### Tech stack
- **Flutter** (Material 3 UI)
- **State management**: `flutter_bloc` (`Cubit`)
- **HTTP**: `dio` + `pretty_dio_logger`
- **DI/Service Locator**: `get_it`
- **Local storage**: `shared_preferences`

### Architecture
The codebase follows a feature-first, layered structure:

- **core/**: Cross-cutting concerns shared across features
  - `constant/`: UI assets, colors, strings
  - `di/`: App-wide service locator setup (`GetIt`) in `inject.dart`
  - `network/`: `DioClient`, `ApiService`, and `ApiConstants` (base URL and endpoints)
  - `routing/`: Central `onGenerateAppRoute` and typed route names in `AppRoutes`
  - `services/`: Cross-feature services (e.g., `StorageService` for auth persistence)

- **features/**: Each feature is self-contained
  - `cubit/`: Business logic and states per feature screen/flow
  - `models/`: Request/response/domain models
  - `services/`: API-facing services per feature (use `ApiService`)
  - `ui/`: Screens and widgets composing the feature UI

- **shared/**: Reusable widgets/components shared across features

#### State management (Cubit)
- Each feature exposes `...Cubit` and `...State` classes.
- Cubits depend on feature services (registered in `GetIt`) and emit typed states for UI.

#### Networking
- `DioClient` configures base URL, timeouts, headers, and logging.
- `ApiService` wraps `DioClient` to expose typed `get/post/put/delete/patch` and token helpers.
- Base URL and endpoints live in `core/network/api_constants.dart`.

#### Dependency injection
- `core/di/inject.dart` registers singletons and factories in `GetIt`:
  - Shared: `SharedPreferences`, `StorageService`, `DioClient`, `ApiService`
  - Services: `AuthService`, `CategoriesService`, `ProductsService`, `SettingsService`
  - Cubits: Auth, Home (categories/products/offers/search/details), Cart, Checkout, Favorites, Reviews, Settings

#### Routing
- Centralized in `core/routing/app_router.dart` using `onGenerateRoute` and `AppRoutes` constants.
- Strongly-typed navigation arguments per screen.

#### Storage
- `StorageService` persists token, user, and login response via `shared_preferences`.
- Helpers to set/clear auth token are exposed via `ApiService`/`DioClient`.

### Features (high level)
- **Onboarding/Splash**: First-run and entry flows
- **Auth**: Login/Signup, token persistence
- **Home**: Categories, products, offers, product details, search
- **Cart & Checkout**: Cart management and order creation
- **Favorites**: Wishlist
- **Reviews**: Add review for product
- **Settings**: Update profile, contact us

### Project structure (simplified)
```
lib/
  core/
    constant/        # colors, assets, texts
    di/              # GetIt setup
    network/         # Dio client, Api service, endpoints
    routing/         # App routes and generator
    services/        # storage and cross-cutting services
  features/
    auth/            # cubits, models, services, UI
    home/            # categories, products, offers, search
    cart/            # cart management
    checkout/        # order creation
    favorites/       # wishlist
    reviews/         # add review
    settings/        # profile, contact us
    onboarding/, splash/
  shared/            # common widgets
  main.dart          # app entry and DI init
```
