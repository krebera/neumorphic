# Neumorphic Design in Swift UI

All the cool kids are doing it these days.

![light](https://github.com/krebera/neumorphic/blob/master/screenshots/lightgif.gif "Light Demo")
![dark](https://github.com/krebera/neumorphic/blob/master/screenshots/darkgif.gif "Dark Demo")

I originally wrote a worse version of this library for personal use, discovered Costa's Neumorphic package [over here](https://github.com/costachung/neumorphic) and ended up fusing the two together.

This library distills a lot of the neumorphic design down into a view modifier that takes a `shape` and a `height` argument. A `height` of -1.0 will be a full depression and a `height` of 1.0 will be a full elevation.

I also included some Color extensions and some linear interpolation methods to help with easing. This means that you don't have to stick with normal eggshell and shadow colors! Make it cherry red if you so desire. Use the `height` modifier in tandem with spring animations to set up cool transitions!

![color](https://github.com/krebera/neumorphic/blob/master/screenshots/colorgif.gif "Color Demo")
![transition](https://github.com/krebera/neumorphic/blob/master/screenshots/transition.gif "Transition Demo")

## Basic Usage

### Colors
I've included extensions for both Color and CGColor since they're the most compatible classes these days.
The user has access to some static `Color`s that all have the prefix `n` amd static `CGColor`s that all have the prefix `cg`:

**Bright Colors:**
- nNeutral
- nHighlight
- nShadow
- nAlternate

**Dark Colors:**
- nNeutralDark
- nHighlightDark
- nShadowDark
- nAlternateDark

The *alternate* color is what you would use for readable text / high contrast accents.

You can use `colorForHex(rgb: 0xwhatever)` to specify a CGColor from a hex value. You can convert to a Color using `Color(cgColor: mycolor)`

`CGColor` has been extended to include `highlight()`, `shadow()`, and `alternate()`. This allows a user to provide any base color they like and use these functions to generate contrasted, readable text and neumorphic color values that are convincing (most of the time. I'm not great at color theory).

You can also use `interpolate()` to interpolate between one `CGColor` and another if you'd like.

### Setting up a Background
Typically you will want to have the neumorphic base color extend all the way to the edges. `n_bg()` will specify a background color with a default light neumorphic tone.

```swift
ContentView()
.n_bg()
.edgesIgnoringSafeArea(.all)
```

You can also specify any color you'd like using `bg()` (takes a CGColor):
```swift
let mycolor = ContentView()
.bg(color: colorForHex(rgb: 0xFF0000))
.edgesIgnoringSafeArea(.all)
```

### Specifying a shape
A typical usage may look like so:

```swift
Text("Hello, World!")
.neumorphic(RoundedRectangle(cornerRadius: 15), height: 1.0)
.frame(width: 200, height: 200)
```

Although it looks a lot nicer if you bold your text and apply the alternate color in the foreground:

```swift
Text("Hello, World!")
.foregroundColor(Color.nAlternate)
.fontWeight(.bold)
.neumorphic(RoundedRectangle(cornerRadius: 15), height: 1.0)
.frame(width: 200, height: 150)
```

Depressed             |  Elevated
:-------------------------:|:-------------------------:
![hw2](https://github.com/krebera/neumorphic/blob/master/screenshots/hw1.png "Depressed")  |  ![hw1](https://github.com/krebera/neumorphic/blob/master/screenshots/hw2.png "Elevated")

You can add your own custom colors as well.
If you'd like to override all colors, typically in the case of merging with a background color that isn't the default, you can pass a `CGColor` as a `color` argument. If you'd like to set JUST the inside color without affecting the outer shadowing, you can use `innerColor`.

```swift
import SwiftUI
import Neumorphic

let kermit = colorForHex(rgb: 0x89CE94)
let darkGreen = colorForHex(rgb: 0x183A37)

struct ContentView: View {
    var body: some View {
        Text("Hi there!").foregroundColor(Color(cgColor: kermit.alternate())).fontWeight(.bold).neumorphic(Circle(), height: -1.0, color: darkGreen, innerColor: kermit).frame(width: 200, height: 150)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().bg(color: darkGreen).edgesIgnoringSafeArea(.all)
    }
}
```

![multi](https://github.com/krebera/neumorphic/blob/master/screenshots/multi.png "Multi")

### Buttons, too!
Make em squishy!

```swift
Button(action:{}, label: {
            Text("Hello")
            }).neumorphicButtonStyle(Circle())
    }
```

Buttons can also take a normal color and inner color argument.

### Size

There's a default spread multiplier that can help ring in the radiuses and blurs of the shadows / highlights if you'd like. You can specify a `size` parameter of the type `.small`, `.medium`, `.large`. The deafult is `.medium`

Please enjoy and squish away!
