# Architecture Migration Plan: Applying RepoTraffic Learnings to coenttb-com-server

## Executive Summary

This document outlines a comprehensive architectural refactoring of `coenttb-com-server` based on learnings from building `repotraffic-com-server`. The migration transforms the codebase from a multi-repository structure with generic "Server" modules into a domain-driven mono-repo architecture following the Interface/Live pattern.

**Key Changes:**
1. **Mono-repo**: Merge `coenttb-com-shared` into the main repository
2. **Domain-Driven Design**: Organize code by business domains with Interface/Live separation
3. **Swift 6.2 & macOS 15**: Upgrade platform requirements
4. **Enhanced Documentation**: Add comprehensive architectural and setup documentation
5. **Development Tools**: Add build/deployment scripts and testing infrastructure

---

## Current Architecture Analysis

### Repository Structure

**Current State** (Multi-repository):
```
coenttb/
├── coenttb-com-server/          # Main server application
│   ├── Sources/
│   │   ├── Server/              # Executable entry point
│   │   ├── Server Client/       # Client integrations
│   │   ├── Server Database/     # Database layer
│   │   ├── Server Dependencies/ # Dependency configuration
│   │   ├── Server EnvVars/      # Environment variables
│   │   ├── Server Models/       # Domain models
│   │   ├── Server Integration/  # Views and integrations
│   │   ├── Server Translations/ # i18n
│   │   └── Vapor Application/   # Vapor configuration
│   └── Package.swift
└── coenttb-com-shared/          # SEPARATE REPOSITORY
    ├── Sources/
    │   ├── Coenttb Com Shared/  # Shared models (User, Configuration)
    │   └── Coenttb Com Router/  # Routing definitions
    └── Package.swift
```

**Issues with Current Architecture:**
1. ❌ **Separate repository** for shared code complicates development
2. ❌ **Generic naming** ("Server Client", "Server Models") lacks domain context
3. ❌ **Mixed concerns** in modules (e.g., "Server Integration" contains views AND business logic)
4. ❌ **No Interface/Live separation** makes testing and mocking difficult
5. ❌ **Unclear dependencies** between modules
6. ❌ **External package dependency** for shared code requires publishing/versioning

### Package Dependencies

**Current** (coenttb-com-server):
```swift
// 14 external package dependencies
.package(url: "github.com/coenttb/boiler", branch: "main")
.package(url: "github.com/coenttb/coenttb", branch: "main")
.package(url: "github.com/coenttb/coenttb-server", branch: "main")
.package(url: "github.com/coenttb/coenttb-com-shared", branch: "main")  // ← Separate repo
.package(url: "github.com/coenttb/coenttb-blog", branch: "main")
// ... 9 more
```

**Target** (inspired by repotraffic):
```swift
// External dependencies only (no coenttb-com-shared)
.package(url: "github.com/coenttb/boiler", from: "0.0.1")
.package(url: "github.com/coenttb/swift-server-foundation", from: "0.0.1")
.package(url: "github.com/coenttb/swift-html", from: "0.0.1")
// ... etc (all external, versioned dependencies)
```

---

## Target Architecture (RepoTraffic Pattern)

### Mono-repo Domain Structure

```
coenttb-com-server/                    # SINGLE REPOSITORY
├── Sources/
│   ├── coenttb_com/                   # Marketing site executable (www.coenttb.com)
│   │   └── main.swift
│   ├── coenttb_com_app/               # Main application executable (app.coenttb.com, if needed)
│   │   ├── Jobs/                       # Background jobs
│   │   ├── Vapor.Application.configure.swift
│   │   └── main.swift
│   │
│   ├── CoenttbRouter/                 # Central routing (from coenttb-com-shared)
│   │   ├── Route.swift
│   │   ├── Route.Website.swift
│   │   ├── Route.API.swift
│   │   ├── Href.swift
│   │   └── Identity.swift
│   │
│   ├── CoenttbUI/                     # Shared UI components
│   │   ├── Components/
│   │   ├── Layouts/
│   │   └── Themes/
│   │
│   ├── CoenttbRecords/                # Database models and queries
│   │   ├── Models/
│   │   ├── Queries/
│   │   └── Migrations/
│   │
│   ├── Blog/                          # Blog domain interface
│   │   ├── Blog.swift
│   │   ├── Blog.Post.swift
│   │   └── Blog.Client.swift
│   ├── BlogLive/                      # Blog implementation
│   │   ├── Blog.Client+Live.swift
│   │   └── Blog.Database.swift
│   │
│   ├── Newsletter/                    # Newsletter domain interface
│   │   ├── Newsletter.swift
│   │   └── Newsletter.Client.swift
│   ├── NewsletterLive/                # Newsletter implementation
│   │   └── Newsletter.Client+Live.swift
│   │
│   ├── Account/                       # User account domain interface
│   │   ├── Account.swift
│   │   └── Account.Client.swift
│   ├── AccountLive/                   # Account implementation
│   │   └── Account.Client+Live.swift
│   │
│   ├── Content/                       # Content management interface
│   │   ├── Content.swift
│   │   └── Content.Client.swift
│   ├── ContentLive/                   # Content implementation
│   │   └── Content.Client+Live.swift
│   │
│   └── ... (other domains as needed)
│
├── Tests/
│   ├── Blog Tests/
│   ├── Newsletter Tests/
│   ├── Account Tests/
│   └── ... (tests per domain)
│
├── Scripts/
│   ├── deploy-container.sh
│   ├── analyze-build-performance.sh
│   └── setup-test-schemes.sh
│
├── docs/
│   └── (architectural documentation)
│
├── Package.swift
├── CLAUDE.md
├── DOMAIN_ARCHITECTURE.md
├── ENVIRONMENT_SETUP.md
└── README.md
```

### Interface/Live Pattern

**Key Principle**: Separate domain interfaces from implementations

```swift
// Sources/Blog/Blog.Client.swift (INTERFACE)
@DependencyClient
public struct Client: Sendable {
    public var fetchPost: @Sendable (Blog.Post.ID) async throws -> Blog.Post
    public var listPosts: @Sendable () async throws -> [Blog.Post]
    public var createPost: @Sendable (Blog.Post.Draft) async throws -> Blog.Post
}

extension DependencyValues {
    public var blog: Blog.Client {
        get { self[Blog.Client.self] }
        set { self[Blog.Client.self] = newValue }
    }
}

// Sources/BlogLive/Blog.Client+Live.swift (IMPLEMENTATION)
extension Blog.Client {
    public static var live: Self {
        Self(
            fetchPost: { id in
                @Dependency(\.defaultDatabase) var db
                return try await db.read { db in
                    try await Blog.Post.fetch(id: id, from: db)
                }
            },
            listPosts: { /* ... */ },
            createPost: { /* ... */ }
        )
    }
}
```

**Benefits:**
- ✅ Clear separation between "what" (interface) and "how" (implementation)
- ✅ Easy to mock for testing
- ✅ Dependencies are explicit and type-safe
- ✅ Interface can be used without implementation (useful for previews, tests)

---

## Detailed Migration Plan

### Phase 1: Repository Consolidation

**Goal**: Merge `coenttb-com-shared` into `coenttb-com-server`

#### Steps:

1. **Copy shared code into server repository**
   ```bash
   # In coenttb-com-server/
   mkdir -p Sources/CoenttbRouter
   mkdir -p Sources/CoenttbShared

   # Copy files from coenttb-com-shared
   cp -r ../coenttb-com-shared/Sources/Coenttb\ Com\ Router/* Sources/CoenttbRouter/
   cp -r ../coenttb-com-shared/Sources/Coenttb\ Com\ Shared/* Sources/CoenttbShared/
   ```

2. **Update Package.swift**
   ```swift
   // REMOVE this dependency
   // .package(url: "https://github.com/coenttb/coenttb-com-shared", branch: "main")

   // ADD new internal targets
   .target(
       name: "CoenttbRouter",
       dependencies: [
           .product(name: "Coenttb Server", package: "coenttb-server"),
           .product(name: "Coenttb Syndication", package: "coenttb-syndication"),
           .product(name: "Coenttb Blog", package: "coenttb-blog"),
           // ... other dependencies
       ]
   ),
   .target(
       name: "CoenttbShared",
       dependencies: [
           "CoenttbRouter",
           .product(name: "Coenttb Server", package: "coenttb-server"),
       ]
   )
   ```

3. **Update all import statements**
   ```swift
   // OLD
   import Coenttb_Com_Router
   import Coenttb_Com_Shared

   // NEW
   import CoenttbRouter
   import CoenttbShared
   ```

4. **Test compilation**
   ```bash
   swift build
   ```

5. **Archive old coenttb-com-shared repository**
   - Add deprecation notice in README
   - Archive the repository on GitHub

#### Estimated Time: 2-4 hours

---

### Phase 2: Domain Identification & Extraction

**Goal**: Identify business domains and create Interface/Live structure

#### Identified Domains (based on current modules):

1. **Blog** - Blog posts, authoring, publishing
2. **Newsletter** - Email subscriptions, campaigns
3. **Account** - User accounts, authentication
4. **Content** - Static pages, projects
5. **Legal** - Terms, privacy policy
6. **Analytics** - Tracking (Google Analytics, Hotjar)
7. **Email** - Transactional emails (Mailgun)
8. **Database** - PostgreSQL operations (centralized)

#### Domain Creation Template:

For each domain (e.g., "Blog"):

1. **Create Interface Target**
   ```
   Sources/Blog/
   ├── Blog.swift                  # Core types
   ├── Blog.Post.swift             # Domain models
   ├── Blog.Client.swift           # Dependency client interface
   └── exports.swift               # Public exports
   ```

2. **Create Live Implementation Target**
   ```
   Sources/BlogLive/
   ├── Blog.Client+Live.swift      # Live implementation
   ├── Blog.Database.swift         # Database operations
   └── Blog.Routes.swift           # Route handlers (if applicable)
   ```

3. **Create Test Target**
   ```
   Tests/Blog Tests/
   ├── Blog.Client.Tests.swift
   └── Blog.Post.Tests.swift
   ```

4. **Update Package.swift**
   ```swift
   .target(
       name: "Blog",
       dependencies: [
           .dependencies,
           .dependenciesMacros,
           .product(name: "TypesFoundation", package: "swift-types-foundation")
       ]
   ),
   .target(
       name: "BlogLive",
       dependencies: [
           "Blog",
           "CoenttbRecords",
           .product(name: "Records", package: "swift-records"),
           .dependencies
       ]
   ),
   .testTarget(
       name: "Blog Tests",
       dependencies: [
           "Blog",
           "BlogLive",
           .dependenciesTestSupport
       ]
   )
   ```

#### Estimated Time: 1-2 weeks (all domains)

---

### Phase 3: Database Layer Consolidation

**Goal**: Create centralized database layer with Records

#### Steps:

1. **Create CoenttbRecords target**
   ```
   Sources/CoenttbRecords/
   ├── Models/
   │   ├── User.swift
   │   ├── BlogPost.swift
   │   ├── NewsletterSubscriber.swift
   │   └── ... (all database models)
   ├── Queries/
   │   ├── User.Queries.swift
   │   ├── BlogPost.Queries.swift
   │   └── ...
   ├── Migrations/
   │   └── v1.0.0_complete_schema.swift
   └── Database.Migrator.coenttb.swift
   ```

2. **Migrate from Fluent to Records**

   Current (Fluent):
   ```swift
   final class User: Model {
       static let schema = "users"
       @ID(key: .id) var id: UUID?
       @Field(key: "email") var email: String
   }
   ```

   Target (Records with @Table):
   ```swift
   @Table("users")
   struct User: Codable, Sendable {
       let id: UUID
       let email: String
       let createdAt: Date
   }

   extension User {
       static func fetch(id: UUID, from db: any Database.Reader) async throws -> User {
           try await select { $0 }
               .from(Self.table)
               .where { $0.id == id }
               .limit(1)
               .execute(db)
               .first ?? throw UserError.notFound
       }
   }
   ```

3. **Create consolidated migration**
   ```swift
   // Sources/CoenttbRecords/Migrations/v1.0.0_complete_schema.swift
   struct CompleteSchema_v1_0_0: Records.Migration {
       func prepare(on db: any Database.Writer) async throws {
           // Create all tables
           try await db.execute("""
               CREATE TABLE users (
                   id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                   email TEXT NOT NULL UNIQUE,
                   created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
               )
           """)
           // ... more tables
       }

       func revert(on db: any Database.Writer) async throws {
           try await db.execute("DROP TABLE users CASCADE")
           // ... drop other tables
       }
   }
   ```

4. **Update configure.swift**
   ```swift
   // Replace Fluent configuration
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
   ```

#### Estimated Time: 1 week

---

### Phase 4: Swift & Platform Upgrades

**Goal**: Modernize to Swift 6.2 and macOS 15

#### Changes:

1. **Package.swift**
   ```swift
   // swift-tools-version: 6.2  // ← Update from 6.1.0

   platforms: [
       .macOS(.v15)  // ← Update from .v14
   ]

   // Add upcoming features
   let swiftSettings: [SwiftSetting] = [
       .enableUpcomingFeature("MemberImportVisibility"),
       .enableUpcomingFeature("StrictUnsafe"),
       .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
   ]

   // Apply to all targets
   for index in package.targets.indices {
       package.targets[index].swiftSettings =
           (package.targets[index].swiftSettings ?? []) + swiftSettings
   }
   ```

2. **Update .swift-version**
   ```
   6.2
   ```

3. **Fix concurrency issues**
   - Add `Sendable` conformances where needed
   - Fix data race warnings
   - Ensure all async contexts are properly isolated

#### Estimated Time: 2-3 days

---

### Phase 5: Documentation & Tooling

**Goal**: Add comprehensive documentation and development tools

#### Documentation Files:

1. **DOMAIN_ARCHITECTURE.md**
   ```markdown
   # Domain Architecture

   ## Core Domains

   ### Blog Domain
   - **Purpose**: Blog post management and publishing
   - **Interface**: `Blog` target
   - **Implementation**: `BlogLive` target
   - **Models**: `Blog.Post`, `Blog.Author`, `Blog.Category`

   ### Newsletter Domain
   ...
   ```

2. **ENVIRONMENT_SETUP.md**
   ```markdown
   # Environment Setup

   ## Required Environment Variables

   ### Development
   ```bash
   DATABASE_URL=postgresql://...
   MAILGUN_API_KEY=...
   ```

   ### Production
   ...
   ```

3. **Update CLAUDE.md**
   - Document new architecture
   - Migration instructions
   - Common patterns

#### Development Scripts:

1. **Scripts/deploy-container.sh**
   ```bash
   #!/bin/bash
   # Build and deploy Docker container
   docker build --build-arg GH_PAT=$GITHUB_TOKEN -t coenttb-com .
   docker push coenttb-com:latest
   ```

2. **Scripts/analyze-build-performance.sh**
   ```bash
   #!/bin/bash
   # Analyze build times
   xcodebuild -workspace ... \
       -showBuildTimingSummary | tee build-timing.log
   ```

3. **Scripts/setup-test-schemes.sh**
   ```bash
   #!/bin/bash
   # Generate test schemes for all domains
   for domain in Blog Newsletter Account; do
       # Generate scheme
   done
   ```

#### Estimated Time: 1 week

---

## Migration Timeline

### Quick Reference

| Phase | Description | Time | Dependencies |
|-------|-------------|------|--------------|
| 1 | Repository Consolidation | 2-4 hours | None |
| 2 | Domain Extraction | 1-2 weeks | Phase 1 |
| 3 | Database Migration | 1 week | Phase 2 |
| 4 | Swift/Platform Upgrade | 2-3 days | Phase 3 |
| 5 | Documentation & Tooling | 1 week | Phase 4 |

**Total Estimated Time: 4-5 weeks**

### Detailed Schedule

#### Week 1
- **Days 1-2**: Phase 1 - Repository Consolidation
- **Days 3-5**: Phase 2 - Start domain identification, create Blog & Newsletter domains

#### Week 2
- **Days 1-5**: Phase 2 - Create remaining domains (Account, Content, Legal, Analytics, Email)

#### Week 3
- **Days 1-5**: Phase 3 - Database migration to Records
- Start Phase 4 - Begin Swift 6.2 upgrade

#### Week 4
- **Days 1-2**: Complete Phase 4 - Finish Swift upgrade
- **Days 3-5**: Phase 5 - Documentation

#### Week 5
- **Days 1-3**: Phase 5 - Complete tooling scripts
- **Days 4-5**: Final testing, cleanup, deployment

---

## Risk Assessment & Mitigation

### High-Risk Changes

1. **Database Migration (Fluent → Records)**
   - **Risk**: Data loss or corruption
   - **Mitigation**:
     - Full database backup before migration
     - Run migration in staging environment first
     - Create rollback scripts
     - Test thoroughly with production data snapshot

2. **Dependency Breakage**
   - **Risk**: Breaking changes from package updates
   - **Mitigation**:
     - Pin all external dependencies to specific versions
     - Test each dependency update individually
     - Keep detailed changelog

3. **Swift 6.2 Strict Concurrency**
   - **Risk**: Data races and concurrency bugs
   - **Mitigation**:
     - Enable strict concurrency checking incrementally
     - Add comprehensive concurrency tests
     - Use actors and @MainActor appropriately

### Medium-Risk Changes

1. **Route Migration**
   - **Risk**: Broken URLs and 404s
   - **Mitigation**:
     - Create URL compatibility tests
     - Keep routing backwards compatible
     - Implement redirects for changed routes

2. **Module Reorganization**
   - **Risk**: Import confusion and circular dependencies
   - **Mitigation**:
     - Draw dependency graph before refactoring
     - Use clear module boundaries
     - Regular compilation checks

---

## Testing Strategy

### Testing Phases

1. **Unit Tests** (per domain)
   ```swift
   @Suite("Blog Tests")
   struct BlogTests {
       @Test func fetchPost() async throws {
           @Dependency(\.blog) var blog
           let post = try await blog.fetchPost(id: testPostID)
           #expect(post.title == "Test Post")
       }
   }
   ```

2. **Integration Tests** (cross-domain)
   ```swift
   @Suite("Newsletter + Account Integration")
   struct NewsletterAccountTests {
       @Test func subscribeWithAccount() async throws {
           // Test newsletter subscription with user account
       }
   }
   ```

3. **Database Tests** (with test isolation)
   ```swift
   @Suite("Blog Database Tests", .dependency(\.database, try Database.TestDatabase()))
   struct BlogDatabaseTests {
       @Dependency(\.database) var db

       @Test func createPost() async throws {
           try await db.withRollback { db in
               let post = try await Blog.Post.create(draft, in: db)
               #expect(post.id != nil)
           }
       }
   }
   ```

4. **E2E Tests** (full application)
   ```swift
   @Suite("End-to-End Tests")
   struct E2ETests {
       @Test func blogPostWorkflow() async throws {
           // Create → Publish → View → Edit
       }
   }
   ```

### Test Coverage Goals

- **Unit Tests**: 80%+ coverage per domain
- **Integration Tests**: Critical paths covered
- **Database Tests**: All CRUD operations
- **E2E Tests**: Major user flows

---

## Rollback Plan

### If Migration Fails

1. **Immediate Rollback**
   ```bash
   # Revert to previous Docker image
   docker pull coenttb-com:previous
   docker run coenttb-com:previous

   # Restore database backup
   pg_restore -d coenttb_production backup.dump
   ```

2. **Git Rollback**
   ```bash
   # Create rollback branch
   git checkout -b rollback-migration
   git revert <migration-commits>
   git push origin rollback-migration

   # Deploy rollback
   ./Scripts/deploy-container.sh
   ```

3. **Communication Plan**
   - Notify users of temporary service disruption
   - Post status updates
   - Document issues encountered

---

## Success Metrics

### Code Quality

- ✅ All tests passing
- ✅ Zero compiler warnings
- ✅ Swift 6 strict concurrency mode enabled
- ✅ 80%+ test coverage

### Architecture

- ✅ All domains follow Interface/Live pattern
- ✅ Clear module boundaries
- ✅ No circular dependencies
- ✅ Dependency injection used throughout

### Documentation

- ✅ Comprehensive DOMAIN_ARCHITECTURE.md
- ✅ Updated CLAUDE.md with new patterns
- ✅ Environment setup documented
- ✅ Migration guide for contributors

### Performance

- ✅ Build time ≤ 2x current
- ✅ App startup time unchanged or improved
- ✅ Database query performance maintained or improved

---

## Post-Migration Tasks

1. **Update CI/CD**
   - Update build scripts for new structure
   - Add domain-specific test jobs
   - Configure deployment pipelines

2. **Update Documentation**
   - Update README with new architecture
   - Create contributor guide
   - Document common patterns

3. **Team Training**
   - Explain Interface/Live pattern
   - Show how to add new domains
   - Review testing strategies

4. **Monitor & Optimize**
   - Track build performance
   - Monitor application metrics
   - Optimize slow domains

---

## Appendix

### A. Domain Mapping (Old → New)

| Current Module | New Domain(s) | Notes |
|----------------|---------------|-------|
| Server | coenttb_com | Executable |
| Server Client | Multiple Live targets | Split by domain |
| Server Database | CoenttbRecords | Centralized |
| Server Models | Domain interfaces | Distributed |
| Server Integration | Domain Live targets | Split by domain |
| Server Translations | Shared or per-domain | TBD |
| Vapor Application | coenttb_com_app | Configuration |
| Coenttb Com Router | CoenttbRouter | Internal target |
| Coenttb Com Shared | CoenttbShared | Internal target |

### B. Package Dependency Changes

**Remove:**
- ❌ `coenttb-com-shared` (merged into mono-repo)

**Keep:**
- ✅ All external dependencies (boiler, swift-html, etc.)
- ✅ Use version tags instead of branch references

**Add (if needed):**
- ✅ Additional domain-specific packages

### C. File Structure Comparison

**Before:**
```
coenttb-com-server/
└── Sources/
    ├── Server/
    ├── Server Client/
    ├── Server Database/
    ├── Server Dependencies/
    ├── Server EnvVars/
    ├── Server Models/
    ├── Server Integration/
    ├── Server Translations/
    └── Vapor Application/
```

**After:**
```
coenttb-com-server/
└── Sources/
    ├── coenttb_com/
    ├── coenttb_com_app/
    ├── CoenttbRouter/
    ├── CoenttbUI/
    ├── CoenttbRecords/
    ├── Blog/ + BlogLive/
    ├── Newsletter/ + NewsletterLive/
    ├── Account/ + AccountLive/
    ├── Content/ + ContentLive/
    └── ... (other domains)
```

---

## Conclusion

This migration represents a significant architectural improvement for `coenttb-com-server`. By applying the lessons learned from building `repotraffic-com-server`, we achieve:

1. **Simpler Development**: Mono-repo eliminates multi-repository complexity
2. **Better Organization**: Domain-driven structure makes code easier to find and understand
3. **Improved Testability**: Interface/Live pattern enables comprehensive testing
4. **Modern Swift**: Swift 6.2 with strict concurrency for safety
5. **Clear Boundaries**: Explicit dependencies and module isolation

The estimated 4-5 week timeline accounts for careful, methodical refactoring with comprehensive testing at each phase. The result will be a more maintainable, scalable, and robust codebase that serves as an excellent reference for Swift server-side development.

---

**Document Version**: 1.0
**Last Updated**: 2025-10-08
**Author**: Claude Code Analysis
