import 'package:faker/faker.dart' ;
import 'package:scoped_model/scoped_model.dart';
import 'package:sep_30_eve/Contact_dao.dart';
import 'package:sep_30_eve/main.dart';

class contatacsModel extends Model{
  final ContactDao _contactDao=ContactDao();
  List<Contact>? _contacts;
  bool _isLoading=true;
  bool get isLoading=>_isLoading;
  List<Contact>? get contacts{
    return _contacts;
  }
  Future loadContacts()async{
    _isLoading=true;
    notifyListeners();
    _contacts=await _contactDao.getAllInSortedOrder();
    _isLoading=false;
    notifyListeners();
  }
  Future changeFavouriteStatus(Contact contact)async{
    contact.isFavourite=!contact.isFavourite;
    await _contactDao.update(contact);
    await _contactDao.getAllInSortedOrder();
    notifyListeners();
  }
  // void _sortContacts(){
  //   _contacts.sort((a,b){
  //     int comparisonResult;
  //     comparisonResult=_compareBasedOnFavouriteStatus(a, b);
  //     if(comparisonResult==0){
  //       comparisonResult=_compareAlphabetically(a, b);
  //     }
  //     return comparisonResult;
  //   });
  // }
  // int _compareBasedOnFavouriteStatus(Contact a,Contact b){
  //   if(a.isFavourite){
  //     return -1;
  //   }
  //   else if(b.isFavourite){
  //     return 1;
  //   }
  //   else
  //     return 0;
  // }
  // int _compareAlphabetically(Contact a,Contact b){
  //   return a.name.compareTo(b.name);
  // }
  Future addContact(Contact contact)async{

   await _contactDao.insert(contact);
   await loadContacts();
    notifyListeners();
  }
  Future updateContact(Contact contact)async{
    await _contactDao.update(contact);
    await loadContacts();
    notifyListeners();
  }
  Future deleteContact(Contact contact)async{
    await _contactDao.delete(contact);
    await loadContacts();
    notifyListeners();
  }
}