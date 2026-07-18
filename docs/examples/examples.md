# examples — quick code snippets

## Minimal SharedValue example

```dart
class MyWidgetState extends State<MyWidget> with TickerProviderStateMixin {
  late final SharedValue opacity;

  @override
  void initState() {
    super.initState();
    opacity = SharedValue(0.0, vsync: this);
    // start an animation
    opacity.value = withTiming(1.0, duration: 250);
  }

  @override
  void dispose() {
    opacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: opacity.internalListenable,
      builder: (_, __) => Opacity(
        opacity: opacity.value,
        child: child,
      ),
    );
  }
}
```
