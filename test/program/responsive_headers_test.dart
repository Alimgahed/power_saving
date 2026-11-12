import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:power_saving/core/widgets/section_header.dart';
import 'package:power_saving/core/widgets/enterprise_card.dart';
import 'package:power_saving/core/widgets/custom_app_bar.dart';

void main() {
  const title = 'بيانات المحطة والتكنولوجيا ومعلومات استهلاك المياه والطاقة';
  for (final width in [375.0, 768.0, 1440.0]) {
    for (final scale in [1.0, 2.0]) {
      for (final kind in ['section', 'card']) {
        testWidgets(
          '$kind header preserves full title and actions at $width x$scale',
          (tester) async {
            tester.view.physicalSize = Size(width, 900);
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.resetPhysicalSize);
            addTearDown(tester.view.resetDevicePixelRatio);
            var taps = 0;
            await tester.pumpWidget(
              MaterialApp(
                home: MediaQuery(
                  data: MediaQueryData(
                    size: Size(width, 900),
                    textScaler: TextScaler.linear(scale),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Scaffold(
                      body: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child:
                              kind == 'section'
                                  ? const SectionHeader(
                                    title: title,
                                    icon: Icons.water,
                                  )
                                  : EnterpriseCard(
                                    title: title,
                                    trailing: IconButton(
                                      onPressed: () => taps++,
                                      icon: const Icon(Icons.refresh),
                                    ),
                                    child: const Text('content'),
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            expect(tester.takeException(), isNull);
            expect(find.text(title), findsOneWidget);
            final text = tester.widget<Text>(find.text(title));
            expect(text.maxLines, isNull);
            expect(text.overflow, isNot(TextOverflow.ellipsis));
            if (kind == 'card') {
              await tester.tap(find.byIcon(Icons.refresh));
              expect(taps, 1);
              expect(find.text('content'), findsOneWidget);
            }
          },
        );
      }
    }
  }
  testWidgets('shared back action exposes localized accessible name', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(appBar: CustomAppBar(title: 'test'))),
    );
    final button = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.arrow_forward),
    );
    expect(button.tooltip, isNotNull);
  });
}
