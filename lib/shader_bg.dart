import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class ShaderBgWidget extends StatefulWidget {
  const ShaderBgWidget({super.key});

  @override
  State<ShaderBgWidget> createState() => _ShaderBgWidgetState();
}

class _ShaderBgWidgetState extends State<ShaderBgWidget>
    with SingleTickerProviderStateMixin {
  Ticker? _ticker;

  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() {
        _elapsed = elapsed;
      });
    });
    _ticker?.start();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'shaders/test.frag',
      (BuildContext context, FragmentShader shader, _) {
        return AnimatedSampler(
          (image, size, canvas) {
            _configureShader(shader, size, _elapsed);
            _drawShaderRect(shader, size, canvas);
          },
          child: const Center(),
        );
      },
    );
  }

  void _configureShader(FragmentShader shader, Size size, Duration time) {
    shader
      ..setFloat(0, size.width) // resolution
      ..setFloat(1, size.height) // resolution
      ..setFloat(2, time.inMilliseconds.toDouble() / 1000.0);
  }

  void _drawShaderRect(FragmentShader shader, Size size, Canvas canvas) {
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      Paint()..shader = shader,
    );
  }
}
