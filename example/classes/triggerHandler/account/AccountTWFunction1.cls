public with sharing class AccountTWFunction1 extends TW_Function {
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

  private Boolean beforeUpdatefilter(SObject oldRecord, SObject newRecord) {
    return ((Account) oldRecord).Name != ((Account) newRecord).Name;
  }
}
