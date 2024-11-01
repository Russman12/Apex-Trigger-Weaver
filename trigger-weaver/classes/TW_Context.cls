public with sharing class TW_Context {
  public final List<SObject> oldRecords;
  public final List<SObject> newRecords;
  public final Map<Id, SObject> oldRecordsMap;
  public final Map<Id, SObject> newRecordsMap;
  public final List<SObject> queriedRecords;
  public final Map<Id, SObject> queriedRecordsMap;

  public TW_Context() {
    this.oldRecords = Trigger.old;
    this.newRecords = Trigger.new;
    this.oldRecordsMap = Trigger.oldMap;
    this.newRecordsMap = Trigger.newMap;
  }
  public TW_Context(ASB soql) {
    this();
    this.queriedRecords = soql.query(new Map<String, Object>{ 'records' => Trigger.new });
    this.queriedRecordsMap = new Map<Id, SObject>(this.queriedRecords);
  }
}
