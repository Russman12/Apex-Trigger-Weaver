public with sharing class ContactTWAccNameMismatch extends TW_Function {
  public ContactTWAccNameMismatch() {
    super(ContactTWAccNameMismatch.class);
  }

  protected override ASB_Select afterUpdateSelection(ASB_Select selection) {
    return selection.parent(Contact.AccountId, Account.Name);
  }

  protected override List<SObject> afterUpdate(SObject oldRecord, SObject newRecord, SObject queriedRecord) {
    Contact oldContact = (Contact) oldRecord;
    Contact newContact = (Contact) newRecord;
    Contact queriedContact = (Contact) queriedRecord;

    List<Account> accUpdates = new List<Account>();
    if (queriedContact.Account.Name != newContact.Name) {
      accUpdates.add(new Account(Id = queriedContact.Account.Id, Name = ContactBusinessLogic.fullName(newContact)));
    }
    update accUpdates;

    return null;
  }
  //TODO: add filter to check for contact name change
}
