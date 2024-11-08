public with sharing class ContactTWAccNameMismatch extends TW_Function {
  public ContactTWAccNameMismatch() {
    super(ContactTWAccNameMismatch.class);
  }

  protected override void afterUpdatePreProcess(TW_Context ctx) {
    ctx.addQuerySelection(ASB_Select.make().parent(Contact.AccountId, Account.Name));
  }

  /**
   * Only when FirstName or LastName has changed
   */
  protected override Boolean afterUpdateFilter(TW_Context ctx, SObject oldRecord, SObject newRecord) {
    Contact oldContact = (Contact) oldRecord;
    Contact newContact = (Contact) newRecord;
    return oldContact.FirstName != newContact.FirstName || oldContact.LastName != newContact.LastName;
  }

  protected override List<SObject> afterUpdate(TW_Context ctx, SObject oldRecord, SObject newRecord, SObject queriedRecord) {
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
}
