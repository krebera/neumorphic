# Neumorphic

All the cool kids are doing it these days.


![light](https://github.com/krebera/neumorphic/blob/master/screenshots/lightgif.gif "Light Demo")
![dark](https://github.com/krebera/neumorphic/blob/master/screenshots/darkgif.gif "Dark Demo")

I originally wrote a worse version of this library for personal use, discovered Costa's Neumorphic package [over here](https://github.com/costachung/neumorphic) and ended up fusing the two together.

This library distills a lot of the neumorphic design down into a view modifier that takes a `shape` and a `height` argument. A `height` of -1.0 will be a full depression and a `height` of 1.0 will be a full elevation.

I also included some Color extensions and some linear interpolation methods to help with easing. This means that you don't have to stick with normal eggshell and shadow colors! Make it cherry red if you so desire.
