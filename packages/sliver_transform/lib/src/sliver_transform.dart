import 'package:flutter/widgets.dart';
import 'package:sliver_transform/src/rendering/render_sliver_transform.dart';

class SliverTransform extends SingleChildRenderObjectWidget {
  const SliverTransform({
    super.key,
    required this.transform,
    this.origin,
    this.alignment,
    bool? toggled,
    Widget? sliver,
  })  : toggled = toggled ?? true,
        super(child: sliver);

  SliverTransform.rotate({
    super.key,
    required double angle,
    this.origin,
    this.alignment = Alignment.center,
    bool? toggled,
    Widget? sliver,
  })  : transform = Matrix4.rotationZ(angle),
        toggled = toggled ?? angle != 0.0,
        super(child: sliver);

  SliverTransform.translate({
    super.key,
    required Offset offset,
    bool? toggled,
    Widget? sliver,
  })  : transform = Matrix4.translationValues(offset.dx, offset.dy, 0.0),
        origin = null,
        alignment = null,
        toggled = toggled ?? offset != Offset.zero,
        super(child: sliver);

  SliverTransform.scale({
    super.key,
    required double scale,
    this.origin,
    this.alignment = Alignment.center,
    bool? toggled,
    Widget? sliver,
  })  : transform = Matrix4.diagonal3Values(scale, scale, 1.0),
        toggled = toggled ?? scale != 1.0,
        super(child: sliver);

  final Matrix4 transform;
  final Offset? origin;
  final AlignmentGeometry? alignment;
  final bool toggled;

  @override
  RenderSliverTransform createRenderObject(BuildContext context) => RenderSliverTransform(
        transform: transform,
        origin: origin,
        alignment: alignment,
        toggled: toggled,
        textDirection: Directionality.maybeOf(context),
      );

  @override
  void updateRenderObject(BuildContext context, RenderSliverTransform renderObject) {
    renderObject
      ..transform = transform
      ..origin = origin
      ..alignment = alignment
      ..toggled = toggled
      ..textDirection = Directionality.maybeOf(context);
  }
}
