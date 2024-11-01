public with sharing class AccountTWNameChange extends TW_Function {
  protected override ASB_Select beforeUpdateSelection(ASB_Select asbSelect) {
    return asbSelect.field(Account.Name).subQuery(ASB_SubQuery.relatedBy(Contact.AccountId).selectField(Contact.Name));
  }

  protected override List<SObject> beforeUpdate(SObject oldRecord, SObject newRecord, SObject queriedRecord) {
    Account oldAccount = (Account) oldRecord;
    Account newAccount = (Account) newRecord;
    Account queriedAccount = (Account) queriedRecord;
    if (beforeUpdatefilter(oldRecord, newRecord)) {
      newAccount.Tradestyle = AccountBusinessLogic.contactNames(queriedAccount);
    }

    return null;
  }

  //TODO: make a TW_Function method for this. It should filter out context records affecting query and method calls
  private Boolean beforeUpdatefilter(SObject oldRecord, SObject newRecord) {
    return ((Account) oldRecord).Name != ((Account) newRecord).Name;
  }
}
