# A Tour of `swift-css-types`

`swift-css-types` brings type-safe CSS to the Swift programming language. It models CSS concepts as Swift types, letting you work with styles using Swift's syntax and type system instead of strings.

## Why use `swift-css-types`?

When I first started building web applications with Swift, I found myself missing the type safety I was used to. CSS properties and values as strings led to typos and errors that only showed up at runtime. Here's why `swift-css-types` makes a difference:

- **Catch errors early**: The compiler finds typos and invalid values before you run your code
- **Better tooling**: Get autocomplete suggestions and inline documentation in your editor
- **Works with your workflow**: Fits into code reviews and version control like any other Swift code
- **Testable**: Write unit tests for your styles just like other Swift code
- **AI-friendly**: AI tools generate better CSS when guided by a type system
- **Maintainable**: Track style changes through normal code reviews

## What is `swift-css-types`?

'swift-css-types' translates CSS concepts into Swift types. It covers AtRules, Combinators, Functions, PseudoClasses, PseudoElements, Selectors, Types, and Properties. You can use it with HTML generation libraries like `pointfree-html` or `Elementary`.

```swift
import CSS

// Colors with type safety
let backgroundColor: CSS.Color = .rgba(red: 100, green: 149, blue: 237, alpha: 1) // rgb(100, 149, 237)

// Lengths with proper units
let fontSize: Length = 24.px // 24px
```

## Core Features

### Type-safe CSS Properties

Every CSS property you'd use in a stylesheet has a typed Swift equivalent:

```swift
// Colors that make sense
.color(.blue)                      // color: blue
.color(.hex("#1a2b3c"))            // color: #1a2b3c
.color(.hsl(Hue(180), 50, 50))     // color: hsl(180, 50%, 50%)

// Lengths with real units
.width(200.px)                     // width: 200px
.margin(1.5.em)                    // margin: 1.5em
.padding(10.percent)               // padding: 10%

// Time values for animations
.transitionDuration(.s(0.3))       // transition-duration: 0.3s
.animationDelay(.ms(500))          // animation-delay: 500ms
```

### A Type for Every CSS Value

'swift-css-types' models all CSS value types as Swift types:

- **Colors**: From simple names to complex formats like RGB, HSL, LAB, and LCH
- **Lengths**: All CSS units like pixels, ems, rems, viewport units, and more
- **Angles**: Degrees, radians, turns for rotations and gradients
- **Time**: Seconds and milliseconds for animations and transitions
- **Functions**: calc(), transforms, and other CSS functions
- **Selectors**: Build selectors and combinators with type safety

### Swift-native Syntax

The library feels like it belongs in Swift:

```swift
// Extensions on numeric types for units
let margin = 20.px
let opacity = 0.8
let duration = 0.5.s

// Math operations that make sense
let combinedLength = 100.px + 20.px  // 120px
let halfHeight = 50.vh / 2          // 25vh
let doubledTime = 0.3.s * 2         // 0.6s

// Mixed units create calc() expressions
let mixedCalc = 100.percent - 20.px  // calc(100% - 20px)
```

## Working with Colors

Colors in `swift-css-types` work just like you'd expect in Swift:

```swift
// Create colors in different formats
let red = Color.red
let blue = Color.rgb(red: 0, green: 0, blue: 255)
let transparentGreen = Color.rgba(red: 0, green: 255, blue: 0, alpha: 0.5)
let navy = Color.hex("#000080")
let purple = Color.hsl(hue: Hue(300), saturation: 76, lightness: 72)

// Modern color formats too
let labColor = Color.lab(lightness: 54.3, aAxis: 80.1, bAxis: 69.9)
let lchColor = Color.lch(lightness: 52.2, chroma: 72.2, hue: 50)

// Manipulate colors easily
let darkerBlue = blue.darker(by: 0.2)
let lighterRed = red.lighter(by: 0.3)
let fadedGreen = transparentGreen.opacity(0.3)

// Mix colors together
let mixedColor = Color.mix(.rgb, Color.red, Color.blue)
```

## Working with Lengths

Length values in CSS are everywhere, and `swift-css-types` makes them easy to work with:

```swift
// Different length units for different needs
let width = 100.px
let margin = 1.5.em
let height = 50.vw
let gridColumn = 2.fr

// Do math with lengths
let doubled = width * 2       // 200px
let combined = width + 20.px  // 120px
let halved = height / 2       // 25vw

// Use special keywords when needed
let autoWidth = Length.auto
let maxContent = Length.maxContent
let minContent = Length.minContent
```

## Working with Time and Animation

Animations and transitions need timing values:

```swift
// Create time values
let quickTransition = Time.ms(300)
let longAnimation = Time.s(2)
let delay = 0.5.s

// Use them with related properties
.transitionDuration(quickTransition)
.animationDuration(longAnimation)
.animationDelay(delay)

// Set up animations
.animationName("fadeIn")
.animationDirection(.alternate)
.animationFillMode(.forwards)
.animationTimingFunction(.easeInOut)
```

## Modular Architecture

'swift-css-types' is split into logical modules you can import individually:

- **Types**: Basic data types like Color, Length, and Angle
- **Properties**: CSS property implementations
- **At-rules**: @media, @font-face, and other at-rules
- **Selectors**: CSS selector implementations
- **Pseudo-classes**: :hover, :active, and other pseudo-classes
- **Pseudo-elements**: ::before, ::after, and other pseudo-elements
- **Functions**: CSS function implementations
- **Combinators**: CSS combinator implementations
- **CSS**: Main module that imports everything

This design lets you import just what you need or get everything at once.

## Integration with HTML Generation Libraries

'swift-css-types' works as a common styling language for HTML generation libraries like [pointfree-html](https://github.com/coenttb/pointfree-html) or [Elementary](https://github.com/sliemeobn/elementary). This brings several benefits:

- **Keep concerns separate**: Style logic stays independent from HTML generation
- **Reuse styles**: Use the same styling code with different HTML libraries
- **End-to-end type safety**: From HTML structure to CSS properties
- **Build abstractions**: Create styling components on top of the base library

```swift
import HTML

let document = HTMLPreview.modern {
  h1 { "Type-safe HTML" }
    .color(.blue)
    .fontSize(24.px)
  p { "With type-safe CSS!" }
    .margin(top: 10.px, bottom: 10.px)
    .padding(20.px)
    .backgroundColor(.hex("#f5f5f5"))
}
```

## Benefits of Type Safety

Compared to traditional CSS or CSS-in-JS approaches, `swift-css-types` offers:

1. **No more typos**: The compiler catches property name mistakes
2. **Suggestions as you type**: Your editor shows valid options
3. **Refactoring that works**: Rename properties with confidence
4. **Self-explanatory code**: Types document what values are valid
5. **Fewer surprises**: Catch styling errors before they reach the browser
6. **Better organization**: Use Swift's code organization features
7. **Learn as you go**: Access advanced features only when you need them

## Real-world Examples

Here's how `swift-css-types` handles more complex styling needs:

```swift
// Media queries for responsive design
let responsiveStyles = CSSAtRule.media("(max-width: 768px)") {
    container.padding(10.px)
    header.fontSize(1.2.em)
}

// Grid layouts
.display(.grid)
.gridTemplateColumns(.fr(1), .fr(2), .fr(1))
.gridGap(20.px)

// Complex animations
.animation(
    name: "slide",
    duration: 0.5.s,
    timingFunction: .cubicBezier(0.42, 0, 0.58, 1),
    delay: 0.1.s,
    iterationCount: .infinite,
    direction: .alternate
)
```

## Conclusion

'swift-css-types' brings the safety and expressiveness of Swift to CSS styling. It catches errors early, makes your styling code easier to maintain, and integrates smoothly with the Swift ecosystem.

The library is actively maintained and improved. You can extend it with your own custom properties or values as needed.

Getting started is straightforward:

```swift
// In your Package.swift
dependencies: [
    .package(url: "https://github.com/coenttb/`swift-css-types`.git", from: "0.1.0")
]

// In your Swift file
import CSS

// Now start using type-safe CSS
let textStyle = CSS.Color.blue
let padding = 20.px
```

Give `swift-css-types` a try in your next Swift web project. Your future self will thank you when you're not hunting down that mistyped property name or invalid color value!
