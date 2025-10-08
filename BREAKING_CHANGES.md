# Breaking Changes & Migration Guide

This document details all breaking changes introduced by the architectural refactoring and provides migration paths for each.

## Overview

The refactoring introduces **5 major breaking change categories**:

1. **Repository Structure**: Mono-repo consolidation
2. **Module Names**: Generic → Domain-specific naming
3. **Database Layer**: Fluent → Records migration
4. **Import Statements**: Package reorganization
5. **Platform Requirements**: Swift 6.2 & macOS 15

---

## 1. Repository Structure Changes

### Breaking Change: Separate coenttb-com-shared Repository Removed

**Before:**
```
coenttb/
├── coenttb-com-server/        # Main repo
└── coenttb-com-shared/        # Separate repo (⚠️ REMOVED)
```

**After:**
```
coenttb/
└── coenttb-com-server/        # Single mono-repo
    └── Sources/
        ├── CoenttbRouter/      # Merged from shared
        └── CoenttbShared/      # Merged from shared
```

### Impact
- ❌ Cannot use `coenttb-com-shared` as external package dependency
- ❌ Local development with `USE_LOCAL_PACKAGES` requires updating paths
- ❌ CI/CD must clone only one repository

### Migration Path

**For Package Dependencies:**

```swift
// ❌ OLD (in Package.swift)
.package(url: "https://github.com/coenttb/coenttb-com-shared", branch: "main")

// ✅ NEW - Internal targets, no external dependency
.target(
    name: "CoenttbRouter",
    dependencies: [/* ... */]
)
```

**For Local Development:**

```swift
// ❌ OLD (in .env.development)
USE_LOCAL_PACKAGES=true
# Requires ../coenttb-com-shared to exist

// ✅ NEW - No longer needed
# coenttb-com-shared is part of this repo
```

**For CI/CD:**

```yaml
# ❌ OLD (.github/workflows/test.yml)
- name: Checkout shared
  uses: actions/checkout@v3
  with:
    repository: coenttb/coenttb-com-shared
    path: coenttb-com-shared

# ✅ NEW - Only checkout main repo
- name: Checkout
  uses: actions/checkout@v3
```

---

## 2. Module Name Changes

### Breaking Change: Generic "Server X" Names → Domain Names

All modules have been renamed from generic "Server X" to domain-specific names.

| Old Module Name | New Module Name(s) | Type |
|-----------------|-------------------|------|
| `Server` | `coenttb_com` | Executable |
| `Server Client` | Multiple `*Live` targets | Split by domain |
| `Server Database` | `CoenttbRecords` | Database layer |
| `Server Dependencies` | Removed | Merged into domains |
| `Server EnvVars` | `ServerFoundation` | From external package |
| `Server Models` | Domain interfaces | Distributed |
| `Server Integration` | Domain `*Live` targets | Split by domain |
| `Server Translations` | `CoenttbUI` or per-domain | Shared UI |
| `Vapor Application` | `coenttb_com_app` | Configuration module |

### Migration Path

**Import Statements:**

```swift
// ❌ OLD
import Server_Client
import Server_Database
import Server_Dependencies
import Server_EnvVars
import Server_Models
import Server_Integration
import Server_Translations
import Vapor_Application

// ✅ NEW
import BlogLive                    // Blog implementation
import NewsletterLive              // Newsletter implementation
import CoenttbRecords             // Database models
import CoenttbUI                  // Shared UI & translations
import CoenttbRouter              // Routing
```

**Dependency References:**

```swift
// ❌ OLD
@Dependency(\.serverClient.blog) var blogClient
@Dependency(\.serverClient.newsletter) var newsletterClient

// ✅ NEW (Domain-specific dependencies)
@Dependency(\.blog) var blog
@Dependency(\.newsletter) var newsletter
```

---

## 3. Database Layer Migration (Fluent → Records)

### Breaking Change: Fluent ORM Removed

The entire database layer has been migrated from **Vapor Fluent** to **swift-records**.

#### Model Definitions

**Before (Fluent):**

```swift
import Fluent
import FluentPostgresDriver

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "email")
    var email: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() {}

    init(id: UUID? = nil, email: String) {
        self.id = id
        self.email = email
    }
}
```

**After (Records with @Table):**

```swift
import Records
import StructuredQueries

@Table("users")
struct User: Codable, Sendable {
    let id: UUID
    let email: String
    let createdAt: Date
}

extension User {
    init(email: String) {
        self.init(
            id: UUID(),
            email: email,
            createdAt: Date()
        )
    }
}
```

#### Queries

**Before (Fluent):**

```swift
// Fetch user
let user = try await User.query(on: db)
    .filter(\.$email == email)
    .first()

// Create user
let user = User(email: "user@example.com")
try await user.save(on: db)

// Update user
user.email = "new@example.com"
try await user.update(on: db)

// Delete user
try await user.delete(on: db)
```

**After (Records):**

```swift
// Fetch user
let user = try await select { $0 }
    .from(User.table)
    .where { $0.email == email }
    .limit(1)
    .execute(db)
    .first

// Create user
let user = User(email: "user@example.com")
try await insert { user }
    .into(User.table)
    .execute(db)

// Update user
try await update(User.table)
    .set { $0.email = "new@example.com" }
    .where { $0.id == userId }
    .execute(db)

// Delete user
try await delete(User.table)
    .where { $0.id == userId }
    .execute(db)
```

#### Migrations

**Before (Fluent):**

```swift
struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field("email", .string, .required)
            .field("created_at", .datetime, .required)
            .unique(on: "email")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("users").delete()
    }
}
```

**After (Records):**

```swift
struct CreateUsersTable: Records.Migration {
    func prepare(on db: any Database.Writer) async throws {
        try await db.execute("""
            CREATE TABLE users (
                id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                email TEXT NOT NULL UNIQUE,
                created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
            )
        """)

        // Create indexes
        try await db.execute("""
            CREATE INDEX idx_users_email ON users(email)
        """)
    }

    func revert(on db: any Database.Writer) async throws {
        try await db.execute("DROP TABLE users CASCADE")
    }
}
```

#### Configuration

**Before (Fluent):**

```swift
// configure.swift
import FluentPostgresDriver

extension Vapor.Application {
    static func configure(_ app: Vapor.Application) async throws {
        app.databases.use(.postgres, as: .psql)

        app.migrations.add(CreateUser())
        // ... more migrations

        try await app.autoMigrate()
    }
}
```

**After (Records):**

```swift
// configure.swift
import Records

extension Vapor.Application {
    static func configure(_ app: Vapor.Application) async throws {
        let db = await Database.pool(
            configuration: try .fromEnvironment(),
            minConnections: 5,
            maxConnections: 20
        )

        prepareDependencies {
            $0.defaultDatabase = db
        }

        let migrator = Records.Database.Migrator.coenttb()
        try await migrator.migrate(db)
    }
}
```

### Migration Path

1. **Update Package.swift dependencies:**
   ```swift
   // ❌ REMOVE
   .package(url: "https://github.com/vapor/fluent", from: "4.0.0")
   .package(url: "https://github.com/vapor/fluent-postgres-driver", from: "2.0.0")

   // ✅ ADD
   .package(url: "https://github.com/coenttb/swift-records", from: "0.0.1")
   ```

2. **Convert all Fluent models** to Records @Table structs

3. **Convert all queries** to StructuredQueries syntax

4. **Consolidate migrations** into versioned schema migrations

5. **Update database configuration** in configure.swift

6. **Test thoroughly** with staging database before production

---

## 4. Import Statement Changes

### Breaking Change: Package Reorganization

Due to mono-repo consolidation and module renaming, all import statements must be updated.

#### Complete Import Mapping

```swift
// ===== EXECUTABLES =====

// ❌ OLD
import Server
// ✅ NEW
// (No direct import - executable target)

// ===== ROUTING =====

// ❌ OLD
import Coenttb_Com_Router
import Coenttb_Com_Shared
// ✅ NEW
import CoenttbRouter
import CoenttbShared

// ===== DOMAIN INTERFACES =====

// ❌ OLD (no direct equivalent)
// ✅ NEW
import Blog
import Newsletter
import Account
import Content
import Email

// ===== DOMAIN IMPLEMENTATIONS =====

// ❌ OLD
import Server_Client
// ✅ NEW
import BlogLive
import NewsletterLive
import AccountLive
import ContentLive
import EmailLive

// ===== DATABASE =====

// ❌ OLD
import Server_Database
import Server_Models
// ✅ NEW
import CoenttbRecords

// ===== CONFIGURATION =====

// ❌ OLD
import Server_EnvVars
import Server_Dependencies
// ✅ NEW
import ServerFoundation  // From swift-server-foundation package

// ===== UI & TRANSLATIONS =====

// ❌ OLD
import Server_Translations
import Server_Integration
// ✅ NEW
import CoenttbUI

// ===== VAPOR CONFIGURATION =====

// ❌ OLD
import Vapor_Application
// ✅ NEW
// Internal configuration in coenttb_com_app/configure.swift
```

### Automated Migration Script

```bash
#!/bin/bash
# migrate-imports.sh

# Mapping of old imports to new imports
declare -A IMPORT_MAP=(
    ["Server_Client"]="BlogLive\nimport NewsletterLive\nimport AccountLive"
    ["Server_Database"]="CoenttbRecords"
    ["Server_Models"]="CoenttbRecords"
    ["Server_EnvVars"]="ServerFoundation"
    ["Server_Dependencies"]="CoenttbRouter"
    ["Server_Integration"]="CoenttbUI"
    ["Server_Translations"]="CoenttbUI"
    ["Coenttb_Com_Router"]="CoenttbRouter"
    ["Coenttb_Com_Shared"]="CoenttbShared"
    ["Vapor_Application"]="// Configuration now in coenttb_com_app"
)

# Process all Swift files
find Sources -name "*.swift" | while read file; do
    for old in "${!IMPORT_MAP[@]}"; do
        new="${IMPORT_MAP[$old]}"
        sed -i '' "s/import $old/import $new/" "$file"
    done
done

echo "Import migration complete. Please review changes."
```

---

## 5. Platform & Swift Version Changes

### Breaking Change: Swift 6.2 & macOS 15 Required

**Before:**
```swift
// swift-tools-version: 6.1.0
platforms: [.macOS(.v14)]
```

**After:**
```swift
// swift-tools-version: 6.2
platforms: [.macOS(.v15)]
```

### Impact

1. **Requires Xcode 16.2+** for development
2. **Requires macOS 15+** for local testing
3. **Strict concurrency** mode enabled by default
4. **New language features** available

### Migration Path

#### Update Development Environment

```bash
# Check Swift version
swift --version
# Should output: Swift version 6.2 or higher

# Update .swift-version
echo "6.2" > .swift-version

# Update Package.swift
# Change first line to: // swift-tools-version: 6.2
# Change platforms to: .macOS(.v15)
```

#### Fix Concurrency Issues

Swift 6.2 strict concurrency will flag potential data races:

```swift
// ❌ OLD (may cause data races)
class MyClass {
    var data: [String] = []

    func addData(_ item: String) {
        data.append(item)  // ⚠️ Data race potential
    }
}

// ✅ NEW (Sendable and actor-isolated)
actor MyActor {
    private var data: [String] = []

    func addData(_ item: String) {
        data.append(item)  // ✅ Safe
    }
}

// OR use Sendable struct
struct MyStruct: Sendable {
    let data: [String]  // ✅ Immutable, safe
}
```

#### Enable Upcoming Features

Add to all targets in Package.swift:

```swift
let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("StrictUnsafe"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
]

for index in package.targets.indices {
    package.targets[index].swiftSettings =
        (package.targets[index].swiftSettings ?? []) + swiftSettings
}
```

---

## 6. Dependency Injection Pattern Changes

### Breaking Change: Domain-Specific Dependencies

**Before (Centralized Client):**

```swift
// All clients accessed through serverClient dependency
@Dependency(\.serverClient.blog) var blog
@Dependency(\.serverClient.newsletter) var newsletter
@Dependency(\.serverClient.email) var email
```

**After (Domain-Specific):**

```swift
// Each domain has its own dependency
@Dependency(\.blog) var blog
@Dependency(\.newsletter) var newsletter
@Dependency(\.email) var email
```

### Migration Path

**Step 1: Update Dependency Declarations**

```swift
// ❌ OLD (Server Dependencies target)
extension DependencyValues {
    var serverClient: ServerClient {
        get { self[ServerClient.self] }
        set { self[ServerClient.self] = newValue }
    }
}

// ✅ NEW (Per-domain in respective targets)
// In Blog/Blog.Client.swift
extension DependencyValues {
    public var blog: Blog.Client {
        get { self[Blog.Client.self] }
        set { self[Blog.Client.self] = newValue }
    }
}

// In Newsletter/Newsletter.Client.swift
extension DependencyValues {
    public var newsletter: Newsletter.Client {
        get { self[Newsletter.Client.self] }
        set { self[Newsletter.Client.self] = newValue }
    }
}
```

**Step 2: Update Usage Sites**

```bash
# Find all uses of old pattern
grep -r "@Dependency(\\.serverClient\\." Sources/

# Replace with new pattern
# @Dependency(\.serverClient.blog) → @Dependency(\.blog)
```

**Step 3: Register Live Implementations**

```swift
// ❌ OLD (in configure.swift)
prepareDependencies {
    $0.serverClient = .live
}

// ✅ NEW (in configure.swift)
prepareDependencies {
    $0.blog = .live
    $0.newsletter = .live
    $0.email = .live
    $0.account = .live
    // ... etc for each domain
}
```

---

## Summary of Breaking Changes

### Critical (Must Address)

1. ✅ **Repository structure**: Remove `coenttb-com-shared` dependency
2. ✅ **Database layer**: Migrate all Fluent models to Records
3. ✅ **Import statements**: Update all imports to new module names
4. ✅ **Swift version**: Upgrade to 6.2 and fix concurrency issues

### Important (Should Address)

5. ✅ **Platform version**: Upgrade to macOS 15
6. ✅ **Module names**: Refactor to domain-driven structure
7. ✅ **Dependency injection**: Switch to domain-specific dependencies

### Nice to Have (Can Defer)

8. ⚠️ **Documentation**: Update all docs to reflect new architecture
9. ⚠️ **Scripts**: Add development and deployment scripts
10. ⚠️ **Tests**: Enhance test coverage with new patterns

---

## Rollback Procedure

If migration causes critical issues:

### Immediate Rollback (Production)

```bash
# 1. Revert to previous Docker image
docker pull coenttb-com:pre-migration
docker run -p 8080:8080 coenttb-com:pre-migration

# 2. Restore database backup
pg_restore -d coenttb_production backup_pre_migration.dump

# 3. Update DNS if needed
# (Point to old server)
```

### Code Rollback (Development)

```bash
# 1. Create rollback branch
git checkout -b rollback-to-old-architecture

# 2. Revert migration commits
git log --oneline | grep "migration"
git revert <commit-hashes>

# 3. Test rollback
swift build
swift test

# 4. Deploy rollback
git push origin rollback-to-old-architecture
```

---

## Support & Questions

If you encounter issues during migration:

1. **Check this document** for migration paths
2. **Review ARCHITECTURE_MIGRATION_PLAN.md** for context
3. **Run tests** after each change to catch issues early
4. **Create detailed issue reports** if problems persist

---

**Document Version**: 1.0
**Last Updated**: 2025-10-08
