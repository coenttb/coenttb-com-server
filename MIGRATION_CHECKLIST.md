# Migration Implementation Checklist

Track your progress through the architectural refactoring with this detailed checklist.

---

## Phase 1: Repository Consolidation ⏱️ 2-4 hours

### Pre-Migration Setup

- [ ] **Create backup branch**
  ```bash
  git checkout -b pre-migration-backup
  git push origin pre-migration-backup
  ```

- [ ] **Create feature branch**
  ```bash
  git checkout -b feature/architectural-refactoring
  ```

- [ ] **Document current state**
  ```bash
  swift build > build-log-before.txt
  swift test > test-log-before.txt
  ```

### Merge coenttb-com-shared

- [ ] **Copy shared code**
  ```bash
  mkdir -p Sources/CoenttbRouter
  mkdir -p Sources/CoenttbShared

  cp -r ../coenttb-com-shared/Sources/Coenttb\ Com\ Router/* Sources/CoenttbRouter/
  cp -r ../coenttb-com-shared/Sources/Coenttb\ Com\ Shared/* Sources/CoenttbShared/
  ```

- [ ] **Remove spaces from directory names**
  ```bash
  # Rename all "Server X" directories to "ServerX" for easier command-line usage
  mv "Sources/Server Client" "Sources/ServerClient"
  mv "Sources/Server Database" "Sources/ServerDatabase"
  mv "Sources/Server Dependencies" "Sources/ServerDependencies"
  mv "Sources/Server EnvVars" "Sources/ServerEnvVars"
  mv "Sources/Server Models" "Sources/ServerModels"
  mv "Sources/Server Integration" "Sources/ServerIntegration"
  mv "Sources/Server Translations" "Sources/ServerTranslations"
  mv "Sources/Vapor Application" "Sources/VaporApplication"
  ```

- [ ] **Update Package.swift - Remove external dependency**
  ```swift
  // REMOVE this line:
  // .package(url: "https://github.com/coenttb/coenttb-com-shared", branch: "main")
  ```

- [ ] **Update Package.swift - Add internal targets**
  ```swift
  // ADD these targets
  .target(
      name: "CoenttbRouter",
      dependencies: [
          .product(name: "Coenttb Server", package: "coenttb-server"),
          .product(name: "Coenttb Syndication", package: "coenttb-syndication"),
          .product(name: "Coenttb Blog", package: "coenttb-blog"),
          .product(name: "Coenttb Newsletter", package: "coenttb-newsletter"),
          .product(name: "Translating", package: "swift-translating"),
          .product(name: "Coenttb Web", package: "coenttb-web"),
          .issueReporting
      ]
  ),
  .target(
      name: "CoenttbShared",
      dependencies: [
          "CoenttbRouter",
          .product(name: "Coenttb Server", package: "coenttb-server"),
          .issueReporting
      ]
  )
  ```

- [ ] **Update Package.swift - Fix target dependencies**
  ```swift
  // In all targets that reference coenttb-com-shared:
  // Change from:
  .product(name: "Coenttb Com Shared", package: "coenttb-com-shared")
  .product(name: "Coenttb Com Router", package: "coenttb-com-shared")

  // To:
  "CoenttbShared"
  "CoenttbRouter"
  ```

### Update Import Statements

- [ ] **Find all imports of old packages**
  ```bash
  grep -r "import Coenttb_Com_Router" Sources/
  grep -r "import Coenttb_Com_Shared" Sources/
  ```

- [ ] **Replace imports globally**
  ```bash
  find Sources -name "*.swift" -type f -exec sed -i '' 's/import Coenttb_Com_Router/import CoenttbRouter/g' {} +
  find Sources -name "*.swift" -type f -exec sed -i '' 's/import Coenttb_Com_Shared/import CoenttbShared/g' {} +
  ```

### Verify Phase 1

- [ ] **Build project**
  ```bash
  swift build
  ```

- [ ] **Run tests**
  ```bash
  swift test
  ```

- [ ] **Commit changes**
  ```bash
  git add .
  git commit -m "refactor: consolidate coenttb-com-shared into mono-repo"
  ```

---

## Phase 2: Domain Extraction ⏱️ 1-2 weeks

### Domain: Blog

- [ ] **Create Blog interface target**
  ```bash
  mkdir -p Sources/Blog
  touch Sources/Blog/Blog.swift
  touch Sources/Blog/Blog.Post.swift
  touch Sources/Blog/Blog.Client.swift
  touch Sources/Blog/exports.swift
  ```

- [ ] **Create BlogLive implementation target**
  ```bash
  mkdir -p Sources/BlogLive
  touch Sources/BlogLive/Blog.Client+Live.swift
  touch Sources/BlogLive/Blog.Database.swift
  touch Sources/BlogLive/Blog.Routes.swift
  ```

- [ ] **Create Blog tests**
  ```bash
  mkdir -p Tests/BlogTests
  touch Tests/BlogTests/Blog.Client.Tests.swift
  touch Tests/BlogTests/Blog.Post.Tests.swift
  ```

- [ ] **Add Blog targets to Package.swift**
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

- [ ] **Extract blog types from ServerModels**
  - [ ] Move Blog.Post model
  - [ ] Move Blog.Category model (if exists)
  - [ ] Move Blog.Author model (if exists)

- [ ] **Extract blog client from ServerClient**
  - [ ] Define Blog.Client interface
  - [ ] Implement live client in BlogLive
  - [ ] Add dependency registration

- [ ] **Extract blog views from ServerIntegration**
  - [ ] Move blog view components
  - [ ] Update imports

- [ ] **Test Blog domain**
  ```bash
  swift test --filter BlogTests
  ```

### Domain: Newsletter

- [ ] **Create Newsletter interface target**
  ```bash
  mkdir -p Sources/Newsletter
  touch Sources/Newsletter/Newsletter.swift
  touch Sources/Newsletter/Newsletter.Subscriber.swift
  touch Sources/Newsletter/Newsletter.Client.swift
  touch Sources/Newsletter/exports.swift
  ```

- [ ] **Create NewsletterLive implementation target**
  ```bash
  mkdir -p Sources/NewsletterLive
  touch Sources/NewsletterLive/Newsletter.Client+Live.swift
  touch Sources/NewsletterLive/Newsletter.Database.swift
  touch Sources/NewsletterLive/Newsletter.Mailgun.swift
  ```

- [ ] **Create Newsletter tests**
  ```bash
  mkdir -p Tests/NewsletterTests
  touch Tests/NewsletterTests/Newsletter.Client.Tests.swift
  ```

- [ ] **Add Newsletter targets to Package.swift**

- [ ] **Extract newsletter types**
  - [ ] Move Newsletter.Subscriber model
  - [ ] Move Newsletter.Campaign model (if exists)

- [ ] **Extract newsletter client**
  - [ ] Define Newsletter.Client interface
  - [ ] Implement live client with Mailgun integration

- [ ] **Test Newsletter domain**
  ```bash
  swift test --filter NewsletterTests
  ```

### Domain: Account

- [ ] **Create Account interface target**
- [ ] **Create AccountLive implementation target**
- [ ] **Create Account tests**
- [ ] **Add Account targets to Package.swift**
- [ ] **Extract account types**
  - [ ] User model
  - [ ] Authentication types
  - [ ] Session types
- [ ] **Extract account client**
- [ ] **Test Account domain**

### Domain: Content

- [ ] **Create Content interface target**
- [ ] **Create ContentLive implementation target**
- [ ] **Create Content tests**
- [ ] **Add Content targets to Package.swift**
- [ ] **Extract content types**
  - [ ] Page model
  - [ ] Project model (if exists)
- [ ] **Extract content client**
- [ ] **Test Content domain**

### Domain: Email

- [ ] **Create Email interface target**
- [ ] **Create EmailLive implementation target**
- [ ] **Create Email tests**
- [ ] **Add Email targets to Package.swift**
- [ ] **Extract email types**
  - [ ] Email templates
  - [ ] Email client interface
- [ ] **Integrate with Mailgun**
- [ ] **Test Email domain**

### Domain: Legal

- [ ] **Create Legal interface target**
- [ ] **Create LegalLive implementation target (if needed)**
- [ ] **Add Legal targets to Package.swift**
- [ ] **Extract legal types**
  - [ ] Terms & Conditions
  - [ ] Privacy Policy
  - [ ] Cookie Policy

### Domain: Analytics

- [ ] **Create Analytics interface target**
- [ ] **Create AnalyticsLive implementation target**
- [ ] **Add Analytics targets to Package.swift**
- [ ] **Extract analytics clients**
  - [ ] Google Analytics integration
  - [ ] Hotjar integration

### Create Shared Targets

- [ ] **Create CoenttbUI target**
  ```bash
  mkdir -p Sources/CoenttbUI/{Components,Layouts,Themes}
  ```
  - [ ] Move shared UI components
  - [ ] Move translations
  - [ ] Move HTML document templates

- [ ] **Create CoenttbRecords target**
  ```bash
  mkdir -p Sources/CoenttbRecords/{Models,Queries,Migrations}
  ```
  - [ ] Will be populated in Phase 3

### Remove Old Targets

- [ ] **Remove ServerClient target**
  - [ ] Ensure all functionality moved to domain Live targets

- [ ] **Remove ServerModels target**
  - [ ] Ensure all models moved to domain interfaces

- [ ] **Remove ServerIntegration target**
  - [ ] Ensure all views moved to CoenttbUI or domain targets

- [ ] **Remove ServerDependencies target**
  - [ ] Dependencies now in individual domains

- [ ] **Remove ServerTranslations target**
  - [ ] Moved to CoenttbUI

### Update Main Executables

- [ ] **Rename Server to coenttb_com**
  ```bash
  mv Sources/Server Sources/coenttb_com
  ```

- [ ] **Create coenttb_com_app (if needed)**
  ```bash
  mkdir -p Sources/coenttb_com_app
  ```

- [ ] **Update Package.swift products**
  ```swift
  .executable(name: "coenttb_com", targets: ["coenttb_com"])
  // Optional:
  .executable(name: "coenttb_com_app", targets: ["coenttb_com_app"])
  ```

### Verify Phase 2

- [ ] **Build all domains**
  ```bash
  swift build
  ```

- [ ] **Run all tests**
  ```bash
  swift test
  ```

- [ ] **Check dependency graph**
  ```bash
  swift package show-dependencies
  ```

- [ ] **Commit changes**
  ```bash
  git add .
  git commit -m "refactor: extract domain modules with Interface/Live pattern"
  ```

---

## Phase 3: Database Migration (Fluent → Records) ⏱️ 1 week

### Setup

- [ ] **Create database backup**
  ```bash
  pg_dump -Fc coenttb_development > backup_pre_records_migration.dump
  ```

- [ ] **Add swift-records dependency**
  ```swift
  // In Package.swift:
  .package(url: "https://github.com/coenttb/swift-records", from: "0.0.1")
  ```

- [ ] **Create CoenttbRecords target structure**

### Convert Models

- [ ] **User model**
  ```swift
  // From: final class User: Model
  // To: @Table("users") struct User: Codable, Sendable
  ```

- [ ] **Blog.Post model**
- [ ] **Newsletter.Subscriber model**
- [ ] **All other Fluent models**

### Create Migrations

- [ ] **Create v1.0.0_complete_schema.swift**
  ```bash
  touch Sources/CoenttbRecords/Migrations/v1.0.0_complete_schema.swift
  ```

- [ ] **Define all tables**
  ```swift
  struct CompleteSchema_v1_0_0: Records.Migration {
      func prepare(on db: any Database.Writer) async throws {
          // CREATE TABLE users ...
          // CREATE TABLE blog_posts ...
          // CREATE TABLE newsletter_subscribers ...
          // ... all tables
      }

      func revert(on db: any Database.Writer) async throws {
          // DROP TABLE ... CASCADE
      }
  }
  ```

- [ ] **Create indexes**
  ```sql
  CREATE INDEX idx_users_email ON users(email);
  CREATE INDEX idx_blog_posts_published_at ON blog_posts(published_at);
  -- ... more indexes
  ```

### Create Migrator

- [ ] **Create Database.Migrator.coenttb.swift**
  ```swift
  extension Records.Database.Migrator {
      public static func coenttb() -> Self {
          Self(
              migrations: [
                  CompleteSchema_v1_0_0()
              ],
              versionKey: "coenttb_schema_version"
          )
      }
  }
  ```

### Update Queries

- [ ] **Convert all Fluent queries to StructuredQueries**

  For each domain:
  - [ ] Blog queries
  - [ ] Newsletter queries
  - [ ] Account queries
  - [ ] Content queries

- [ ] **Example conversion:**
  ```swift
  // OLD (Fluent)
  let posts = try await BlogPost.query(on: db)
      .filter(\.$published == true)
      .sort(\.$publishedAt, .descending)
      .limit(10)
      .all()

  // NEW (Records)
  let posts = try await select { $0 }
      .from(BlogPost.table)
      .where { $0.published == true }
      .orderBy { $0.publishedAt.desc }
      .limit(10)
      .execute(db)
  ```

### Update Configuration

- [ ] **Update VaporApplication/configure.swift**
  ```swift
  // REMOVE Fluent configuration
  // app.databases.use(.postgres, as: .psql)
  // app.migrations.add(...)

  // ADD Records configuration
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

- [ ] **Remove Fluent from Package.swift**
  ```swift
  // REMOVE:
  .package(url: "https://github.com/vapor/fluent", ...)
  .package(url: "https://github.com/vapor/fluent-postgres-driver", ...)
  ```

### Testing

- [ ] **Test migrations in development**
  ```bash
  # Drop development database
  dropdb coenttb_development
  createdb coenttb_development

  # Run migrations
  swift run coenttb_com migrate
  ```

- [ ] **Test queries**
  ```bash
  swift test
  ```

- [ ] **Test with production data snapshot**
  ```bash
  # Restore production snapshot to staging
  pg_restore -d coenttb_staging production_snapshot.dump

  # Run migrations on staging
  DATABASE_URL=postgresql://...staging swift run coenttb_com migrate
  ```

### Verify Phase 3

- [ ] **All tests pass**
- [ ] **Database schema matches expected**
- [ ] **Performance benchmarks acceptable**
- [ ] **Commit changes**
  ```bash
  git add .
  git commit -m "refactor: migrate from Fluent to Records database layer"
  ```

---

## Phase 4: Swift & Platform Upgrade ⏱️ 2-3 days

### Update Versions

- [ ] **Update .swift-version**
  ```bash
  echo "6.2" > .swift-version
  ```

- [ ] **Update Package.swift header**
  ```swift
  // swift-tools-version: 6.2
  ```

- [ ] **Update platform requirements**
  ```swift
  platforms: [
      .macOS(.v15)
  ]
  ```

### Enable Upcoming Features

- [ ] **Add swift settings**
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

### Fix Concurrency Issues

- [ ] **Build and collect warnings**
  ```bash
  swift build 2>&1 | tee concurrency-warnings.txt
  ```

- [ ] **Fix data race warnings**
  - [ ] Add `Sendable` conformances
  - [ ] Use actors where needed
  - [ ] Isolate to @MainActor where appropriate

- [ ] **Fix nonisolated(unsafe) warnings**
  - [ ] Review each case
  - [ ] Use proper isolation or mark as `nonisolated(unsafe)` if truly safe

### Update Dependencies

- [ ] **Check all dependencies for Swift 6.2 compatibility**
  ```bash
  swift package update
  ```

- [ ] **Update to versioned dependencies**
  ```swift
  // Change from:
  .package(url: "...", branch: "main")

  // To:
  .package(url: "...", from: "0.0.1")
  ```

### Verify Phase 4

- [ ] **Build with no warnings**
  ```bash
  swift build
  ```

- [ ] **Run tests**
  ```bash
  swift test
  ```

- [ ] **Check binary size**
  ```bash
  ls -lh .build/debug/coenttb_com
  ```

- [ ] **Commit changes**
  ```bash
  git add .
  git commit -m "chore: upgrade to Swift 6.2 and macOS 15"
  ```

---

## Phase 5: Documentation & Tooling ⏱️ 1 week

### Documentation

- [ ] **Create DOMAIN_ARCHITECTURE.md**
  - [ ] Document each domain
  - [ ] Show Interface/Live pattern
  - [ ] Provide examples

- [ ] **Create ENVIRONMENT_SETUP.md**
  - [ ] List all environment variables
  - [ ] Provide example .env files
  - [ ] Document local development setup

- [ ] **Update CLAUDE.md**
  - [ ] Document new architecture
  - [ ] Update development workflows
  - [ ] Add troubleshooting section

- [ ] **Update README.md**
  - [ ] Reflect new architecture
  - [ ] Update quick start guide
  - [ ] Update ecosystem links

- [ ] **Create API_DOCUMENTATION.md (if applicable)**
  - [ ] Document all API endpoints
  - [ ] Show request/response examples
  - [ ] Document authentication

### Scripts

- [ ] **Create Scripts directory**
  ```bash
  mkdir -p Scripts
  ```

- [ ] **Scripts/deploy-container.sh**
  ```bash
  #!/bin/bash
  # Build Docker image
  docker build --build-arg GH_PAT=$GITHUB_TOKEN -t coenttb-com .

  # Push to registry
  docker push coenttb-com:latest

  # Deploy (Heroku/Railway/custom)
  # ...
  ```

- [ ] **Scripts/analyze-build-performance.sh**
  ```bash
  #!/bin/bash
  # Analyze build times per target
  xcodebuild -workspace ... \
      -showBuildTimingSummary \
      | tee build-timing-$(date +%Y%m%d).log
  ```

- [ ] **Scripts/setup-test-schemes.sh**
  ```bash
  #!/bin/bash
  # Generate Xcode schemes for testing domains
  for domain in Blog Newsletter Account Content; do
      # Generate scheme
  done
  ```

- [ ] **Scripts/run-migrations.sh**
  ```bash
  #!/bin/bash
  # Run database migrations
  swift run coenttb_com migrate
  ```

- [ ] **Make scripts executable**
  ```bash
  chmod +x Scripts/*.sh
  ```

### CI/CD Updates

- [ ] **Update .github/workflows/test.yml**
  - [ ] Update Swift version to 6.2
  - [ ] Remove coenttb-com-shared checkout
  - [ ] Add domain-specific test jobs

- [ ] **Update .github/workflows/deploy.yml**
  - [ ] Update Docker build
  - [ ] Update deployment steps

### Additional Files

- [ ] **Create .gitattributes**
  ```
  *.swift diff=swift
  *.md diff=markdown
  ```

- [ ] **Update .gitignore**
  ```
  # Build artifacts
  .build/
  *.build/

  # IDE
  .swiftpm/
  *.xcodeproj
  *.xcworkspace

  # Environment
  .env*
  !.env.example

  # Logs
  *.log
  ```

- [ ] **Create .env.example**
  ```bash
  # Server
  HOSTNAME=0.0.0.0
  PORT=8080
  ENV=development

  # Database
  DATABASE_URL=postgresql://user:pass@localhost/coenttb_dev

  # Email
  MAILGUN_API_KEY=your-key-here
  MAILGUN_DOMAIN=mg.coenttb.com

  # Analytics
  GOOGLE_ANALYTICS_ID=G-XXXXXXXXXX
  HOTJAR_ID=your-hotjar-id
  ```

### Verify Phase 5

- [ ] **All documentation complete**
- [ ] **All scripts tested**
- [ ] **CI/CD pipelines working**
- [ ] **Commit changes**
  ```bash
  git add .
  git commit -m "docs: add comprehensive documentation and development tools"
  ```

---

## Final Verification & Deployment

### Pre-Deployment Checks

- [ ] **Full test suite passes**
  ```bash
  swift test
  ```

- [ ] **No compiler warnings**
  ```bash
  swift build 2>&1 | grep warning
  # Should return nothing
  ```

- [ ] **Code review**
  - [ ] Review all changes
  - [ ] Check for TODOs/FIXMEs
  - [ ] Verify naming consistency

- [ ] **Performance testing**
  - [ ] Load testing
  - [ ] Memory profiling
  - [ ] Database query performance

### Staging Deployment

- [ ] **Deploy to staging**
  ```bash
  ./Scripts/deploy-container.sh staging
  ```

- [ ] **Smoke tests on staging**
  - [ ] Homepage loads
  - [ ] Blog posts accessible
  - [ ] Newsletter signup works
  - [ ] Contact form works

- [ ] **Integration tests on staging**
  ```bash
  STAGING_URL=https://staging.coenttb.com swift test --filter IntegrationTests
  ```

### Production Deployment

- [ ] **Create production release**
  ```bash
  git tag v2.0.0
  git push origin v2.0.0
  ```

- [ ] **Backup production database**
  ```bash
  pg_dump -Fc coenttb_production > backup_v2.0.0_$(date +%Y%m%d).dump
  ```

- [ ] **Deploy to production**
  ```bash
  ./Scripts/deploy-container.sh production
  ```

- [ ] **Run database migrations**
  ```bash
  # Ensure migrations run automatically or run manually
  DATABASE_URL=$PRODUCTION_DATABASE_URL swift run coenttb_com migrate
  ```

- [ ] **Smoke tests on production**
  - [ ] Homepage loads
  - [ ] Blog accessible
  - [ ] All critical paths work

- [ ] **Monitor for errors**
  - [ ] Check logs
  - [ ] Monitor error tracking
  - [ ] Watch performance metrics

### Post-Deployment

- [ ] **Update changelog**
  - [ ] List all major changes
  - [ ] Note breaking changes
  - [ ] Credit contributors

- [ ] **Announce migration**
  - [ ] Blog post (if appropriate)
  - [ ] Social media update
  - [ ] Email to subscribers (if appropriate)

- [ ] **Archive old repository**
  - [ ] Add deprecation notice to coenttb-com-shared
  - [ ] Archive on GitHub
  - [ ] Update README with redirect

- [ ] **Clean up**
  - [ ] Remove migration branches
  - [ ] Close related issues
  - [ ] Update project board

---

## Troubleshooting

### Build Failures

**Issue**: Swift package resolution fails
```bash
# Solution
rm -rf .build
swift package reset
swift package resolve
```

**Issue**: Circular dependency detected
```bash
# Solution
# Review Package.swift dependency graph
# Ensure no target depends on itself transitively
swift package show-dependencies
```

### Test Failures

**Issue**: Database tests fail
```bash
# Solution
# Ensure test database is clean
dropdb coenttb_test
createdb coenttb_test
swift test
```

**Issue**: Dependency injection failures
```bash
# Solution
# Ensure all Live implementations are registered
# Check prepareDependencies in configure.swift
```

### Runtime Issues

**Issue**: 404 errors on routes
```bash
# Solution
# Check route definitions in CoenttbRouter
# Ensure routes are registered in configure.swift
```

**Issue**: Database connection failures
```bash
# Solution
# Verify DATABASE_URL environment variable
# Check database connection limits
# Review connection pool configuration
```

---

## Completion Criteria

All phases are complete when:

- ✅ All checkboxes in all phases are checked
- ✅ All tests pass
- ✅ No compiler warnings
- ✅ Production deployment successful
- ✅ Documentation complete and accurate
- ✅ No regressions in functionality
- ✅ Performance metrics acceptable
- ✅ Team trained on new architecture

---

**Checklist Version**: 1.0
**Last Updated**: 2025-10-08

**Progress**: 0 / 200+ tasks complete (update as you go)
