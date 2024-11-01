public class TW_Handler {
  private static final Set<System.TriggerOperation> QUERY_CONTEXTS = new Set<System.TriggerOperation>{
    System.TriggerOperation.BEFORE_UPDATE,
    System.TriggerOperation.AFTER_UPDATE,
    System.TriggerOperation.BEFORE_DELETE,
    System.TriggerOperation.AFTER_DELETE,
    System.TriggerOperation.AFTER_UNDELETE
  };

  private List<TW_Function> twFunctions = new List<TW_Function>();
  private final ASB_Select selection;
  private final ASB soql;

  public static TW_Handler make(Schema.SObjectType sObjType) {
    //throw execption if not in trigger context
    if (!Trigger.isExecuting) {
      throw new NonTriggerContextException('Unable to create TW_Handler outside of a trigger context');
    }
    return new TW_Handler(sObjType);
  }

  private TW_Handler(Schema.SObjectType sObjType) {
    if (QUERY_CONTEXTS.contains(Trigger.operationType)) {
      Schema.SObjectField idField = sObjType.getDescribe().fields.getMap().get('Id');
      this.selection = ASB_Select.make().field(idField);
      this.soql = ASB.sObject(sObjType).selection(this.selection).filter(ASB_Where.field(idField).isIn().bind('records'));
    }
  }

  public TW_Handler register(TW_Function function) {
    function.setAction(Trigger.operationType);
    twFunctions.add(function);

    return this;
  }

  public void execute() {
    TW_Context ctx;
    for (TW_Function function : this.twFunctions) {
      function.querySelection(this.selection);
    }
    if (this.soql != null) {
      ctx = new TW_Context(this.soql);
    } else {
      ctx = new TW_Context();
    }
    for (TW_Function function : twFunctions) {
      function.execute(ctx);
    }
  }

  private class NonTriggerContextException extends Exception {
  }
}
