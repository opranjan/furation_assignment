import 'package:flutter_test/flutter_test.dart';
import 'package:furation_assignment/app.dart';
import 'package:furation_assignment/core/di/injection.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    await configureDependencies();
  });

  testWidgets('Home screen shows Saniya greeting and goals', (tester) async {
    await tester.pumpWidget(const LuminaApp());
    await tester.pumpAndSettle();

    final hour = DateTime.now().hour;
    final greeting =
        hour < 12
            ? 'Good Morning,'
            : (hour < 17 ? 'Good Afternoon,' : 'Good Evening,');

    expect(find.text('Saniya'), findsOneWidget);
    expect(find.text(greeting), findsOneWidget);
    expect(find.text("Goal's"), findsOneWidget);
    expect(find.text('No Goals Yet'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
  });
}
