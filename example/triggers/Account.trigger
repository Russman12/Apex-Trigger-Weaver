trigger Account on Account(before insert, before update, before delete, after insert, after update, after delete, after undelete) {
  TW_Handler.make(Account.getSObjectType()).register(new AccountTWFunction1()).execute();
}
