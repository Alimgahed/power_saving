import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:power_saving/features/Counter/controller/counter.dart';
import 'package:power_saving/features/stations/controller/all_stations_controller.dart';
import 'package:power_saving/features/planning/controller/place/places_controller.dart';
import 'package:power_saving/features/chemcails/controller/chemacial.dart';
import 'package:power_saving/features/relations/controller/relations/relation.dart';
import 'package:power_saving/features/technology/controller/technlogy.dart';
import 'package:power_saving/features/technology/model/tech_model.dart';
import 'package:power_saving/features/bill/controller/all_bills.dart';
import 'package:power_saving/features/bill/controller/tech_bills.dart';

class Meters extends CounterController {
  @override
  Future<void> fetchAllCounters({bool isBackground = false}) async {}
}

class Stations extends StationsController {
  @override
  Future<void> getStations({bool isBackground = false}) async {}
}

class Places extends PlacesController {
  @override
  Future<void> allPlaces({bool isBackground = false}) async {}
}

class Chemicals extends Chemacialcontroller {
  @override
  Future<void> getchemicals({
    bool isBackground = false,
    bool force = false,
  }) async {}
}

class Relations extends RelationsController {
  @override
  Future<void> getRelations({
    bool isBackground = false,
    bool force = false,
  }) async {}
}

class Technologies extends TechnlogyController {
  @override
  Future<void> alltechnology({
    bool isBackground = false,
    bool force = false,
  }) async {}
}

class Bills extends AllBills {
  @override
  Future<void> allbills({bool isBackground = false}) async {}
}

class TechBills extends TechBillscontroller {
  @override
  Future<void> allbills({bool isBackground = false}) async {}
}

void main() {
  tearDown(() => Get.reset());
  for (final kind in [
    'meters',
    'stations',
    'places',
    'chemicals',
    'relations',
    'technologies',
    'bills',
    'tech bills',
  ]) {
    for (final close in [false, true]) {
      testWidgets(
        '$kind debounce ${close ? 'stops on close' : 'retains delay and callback'}',
        (tester) async {
          late GetxController c;
          late void Function(String) search;
          late Object Function() state;
          switch (kind) {
            case 'meters':
              final x = Meters();
              c = x;
              search = x.onSearchChanged;
              state = () => x.searchError.value;
            case 'stations':
              final x = Stations();
              c = x;
              search = x.onSearchChanged;
              state = () => x.searchError.value;
            case 'places':
              final x = Places();
              c = x;
              search = x.onSearchChanged;
              state = () => x.searchError.value;
            case 'chemicals':
              final x = Chemicals();
              c = x;
              search = x.onSearchChanged;
              state = () => x.searchError.value;
            case 'relations':
              final x = Relations();
              c = x;
              search = x.onSearchChanged;
              state = () => x.searchError.value;
            case 'technologies':
              final x = Technologies();
              c = x;
              search = x.onSearchChanged;
              state = () => x.filteredTechnologies.length;
            case 'bills':
              final x = Bills();
              c = x;
              search = x.onSearchChanged;
              state = () => x.currentPage.value;
            case 'tech bills':
              final x = TechBills();
              c = x;
              search = x.updateSearchQuery;
              state = () => x.currentPage;
          }
          c.onInit();
          if (c is Technologies) {
            c.filteredTechnologies = [
              TechnologyModel(
                powerPerWater: 1,
                main_type: 'type',
                technologyName: 'name',
              ),
            ];
          }
          if (c is Bills) c.currentPage.value = 7;
          if (c is TechBills) c.currentPage = 7;
          final before = state();
          search('unmatched');
          final delay = kind == 'tech bills' ? 500 : 300;
          await tester.pump(Duration(milliseconds: delay - 1));
          expect(state(), before);
          if (close) c.onClose();
          await tester.pump(const Duration(milliseconds: 1));
          expect(state(), close ? equals(before) : isNot(equals(before)));
          if (!close) c.onClose();
        },
      );
    }
  }
}
