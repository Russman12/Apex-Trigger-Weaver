public with sharing class ContactTWFunction1 extends TW_Function {
  protected override ASB_Select afterUpdateSelection(ASB_Select selection) {
    return selection.parent(Contact.AccountId, Account.Name);
  }
  protected override List<SObject> afterUpdate(SObject oldRecord, SObject newRecord, SObject queriedRecord) {
    Contact oldContact = (Contact) oldRecord;
    Contact newContact = (Contact) newRecord;
    Contact queriedContact = (Contact) queriedRecord;

    if (queriedContact.Account.Name != newContact.Name) {
      return new List<Account>{ new Account(Id = queriedContact.Account.Id, Name = ContactBusinessLogic.fullName(newContact)) };
    }

    return null;
  }
}
