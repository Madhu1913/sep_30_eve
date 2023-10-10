import 'package:sembast/sembast.dart';
import 'package:sep_30_eve/App_dataBase.dart';
import 'package:sep_30_eve/main.dart';

class ContactDao {
  static const String CONTACT_STORE_NAME = 'contacts';
  final _contactStore = intMapStoreFactory.store(CONTACT_STORE_NAME);
  Future insert(Contact contact) async {
    await _contactStore.add((await _db) as DatabaseClient, contact.toMap());
  }

  Future<Database?> get _db async => await AppDataBase.instance.database;
  Future update(Contact contact) async {
    final finder = Finder(filter: Filter.byKey(contact.id));
    await _contactStore.update((await _db) as DatabaseClient, contact.toMap(),
        finder: finder);
  }

  Future delete(Contact contact) async {
    final finder = Finder(filter: Filter.byKey(contact.id));
    await _contactStore.delete((await _db) as DatabaseClient, finder: finder);
  }

  Future<List<Contact>?> getAllInSortedOrder() async {
    final finder = Finder(sortOrders: [
      SortOrder('isFavourite', false),
      SortOrder('name'),
    ]);
    final recordSnapshots =
        await _contactStore.find((await _db) as DatabaseClient, finder: finder);
     return recordSnapshots.map((snapShot){
      final contact=Contact.fromMap(snapShot.value);
      contact.id=snapShot.key;
      return contact;

    }).toList();
  }
}
