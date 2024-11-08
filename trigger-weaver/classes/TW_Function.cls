public abstract class TW_Function {
  private final System.Type t;

  protected TW_Function(System.Type t) {
    this.t = t;
  }

  public System.Type getType() {
    return this.t;
  }

  public List<SObject> filteredRecords(TW_Context ctx) {
    return ctx.filteredRecords(this.t);
  }

  protected virtual void beforeInsertPreProcess(TW_Context ctx) {
  }
  protected virtual void afterInsertPreProcess(TW_Context ctx) {
  }
  protected virtual void beforeUpdatePreProcess(TW_Context ctx) {
  }
  protected virtual void afterUpdatePreProcess(TW_Context ctx) {
  }
  protected virtual void beforeDeletePreProcess(TW_Context ctx) {
  }
  protected virtual void afterDeletePreProcess(TW_Context ctx) {
  }
  protected virtual void afterUndeletePreProcess(TW_Context ctx) {
  }

  protected virtual List<SObject> beforeInsert(TW_Context ctx, SObject newRecord) {
    return null;
  }
  protected virtual List<SObject> afterInsert(TW_Context ctx, SObject newRecord, SObject queriedRecord) {
    return null;
  }
  protected virtual List<SObject> beforeUpdate(TW_Context ctx, SObject oldRecord, SObject newRecord, SObject queriedRecord) {
    return null;
  }
  protected virtual List<SObject> afterUpdate(TW_Context ctx, SObject oldRecord, SObject newRecord, SObject queriedRecord) {
    return null;
  }
  protected virtual List<SObject> beforeDelete(TW_Context ctx, SObject oldRecord, SObject queriedRecord) {
    return null;
  }
  protected virtual List<SObject> afterDelete(TW_Context ctx, SObject oldRecord, SObject queriedRecord) {
    return null;
  }
  protected virtual List<SObject> afterUndelete(TW_Context ctx, SObject newRecord, SObject queriedRecord) {
    return null;
  }

  protected virtual Boolean beforeInsertFilter(TW_Context ctx, SObject newRecord) {
    return true;
  }
  protected virtual Boolean afterInsertFilter(TW_Context ctx, SObject newRecord) {
    return true;
  }
  protected virtual Boolean beforeUpdateFilter(TW_Context ctx, SObject oldRecord, SObject newRecord) {
    return true;
  }
  protected virtual Boolean afterUpdateFilter(TW_Context ctx, SObject oldRecord, SObject newRecord) {
    return true;
  }
  protected virtual Boolean beforeDeleteFilter(TW_Context ctx, SObject oldRecord) {
    return true;
  }
  protected virtual Boolean afterDeleteFilter(TW_Context ctx, SObject oldRecord) {
    return true;
  }
  protected virtual Boolean afterUndeleteFilter(TW_Context ctx, SObject newRecord) {
    return true;
  }

  public void executePreProcess(TW_Context ctx) {
    switch on ctx.getOperation() {
      when BEFORE_INSERT {
        this.beforeInsertPreProcess(ctx);
        for (SObject newRecord : ctx.getNew()) {
          if (this.beforeInsertFilter(ctx, newRecord)) {
            ctx.addFilteredRecord(this.t, newRecord);
          }
        }
      }
      when AFTER_INSERT {
        this.afterInsertPreProcess(ctx);
        for (SObject newRecord : ctx.getNew()) {
          if (this.afterInsertFilter(ctx, newRecord)) {
            ctx.addFilteredRecord(this.t, newRecord);
          }
        }
      }
      when BEFORE_UPDATE {
        this.beforeUpdatePreProcess(ctx);
        for (SObject newRecord : ctx.getNew()) {
          SObject oldRecord = ctx.getOldMap().get(newRecord.Id);
          if (this.beforeUpdateFilter(ctx, oldRecord, newRecord)) {
            ctx.addFilteredRecord(this.t, newRecord);
          }
        }
      }
      when AFTER_UPDATE {
        this.afterUpdatePreProcess(ctx);
        System.debug('checking...');
        for (SObject newRecord : ctx.getNew()) {
          SObject oldRecord = ctx.getOldMap().get(newRecord.Id);
          System.debug(newRecord);
          System.debug(oldRecord);
          if (this.afterUpdateFilter(ctx, oldRecord, newRecord)) {
            System.debug('adding');
            ctx.addFilteredRecord(this.t, newRecord);
          }
        }
      }
      when BEFORE_DELETE {
        this.beforeDeletePreProcess(ctx);
        for (SObject oldRecord : ctx.getOld()) {
          if (this.beforeDeleteFilter(ctx, oldRecord)) {
            ctx.addFilteredRecord(this.t, oldRecord);
          }
        }
      }
      when AFTER_DELETE {
        this.afterDeletePreProcess(ctx);
        for (SObject oldRecord : ctx.getOld()) {
          if (this.afterDeleteFilter(ctx, oldRecord)) {
            ctx.addFilteredRecord(this.t, oldRecord);
          }
        }
      }
      when AFTER_UNDELETE {
        this.afterUndeletePreProcess(ctx);
        for (SObject newRecord : ctx.getNew()) {
          if (this.afterUndeleteFilter(ctx, newRecord)) {
            ctx.addFilteredRecord(this.t, newRecord);
          }
        }
      }
    }
  }

  public void execute(TW_Context ctx) {
    switch on ctx.getOperation() {
      when BEFORE_INSERT {
        for (SObject newRecord : ctx.filteredRecords()) {
          if (this.beforeInsertFilter(ctx, newRecord)) {
            this.beforeInsert(ctx, newRecord);
          }
        }
      }
      when AFTER_INSERT {
        for (SObject newRecord : ctx.filteredRecords()) {
          if (this.afterInsertFilter(ctx, newRecord)) {
            this.afterInsert(ctx, newRecord, ctx.getQueriedRecordMap().get(newRecord.Id));
          }
        }
      }
      when BEFORE_UPDATE {
        for (SObject newRecord : ctx.filteredRecords()) {
          SObject oldRecord = ctx.getOldMap().get(newRecord.Id);
          if (this.beforeUpdateFilter(ctx, oldRecord, newRecord)) {
            this.beforeUpdate(ctx, oldRecord, newRecord, ctx.getQueriedRecordMap().get(newRecord.Id));
          }
        }
      }
      when AFTER_UPDATE {
        for (SObject newRecord : ctx.filteredRecords()) {
          SObject oldRecord = ctx.getOldMap().get(newRecord.Id);
          if (this.afterUpdateFilter(ctx, oldRecord, newRecord)) {
            this.afterUpdate(ctx, oldRecord, newRecord, ctx.getQueriedRecordMap().get(newRecord.Id));
          }
        }
      }
      when BEFORE_DELETE {
        for (SObject oldRecord : ctx.filteredRecords()) {
          if (this.beforeDeleteFilter(ctx, oldRecord)) {
            this.beforeDelete(ctx, oldRecord, ctx.getQueriedRecordMap().get(oldRecord.Id));
          }
        }
      }
      when AFTER_DELETE {
        for (SObject oldRecord : ctx.filteredRecords()) {
          if (this.afterDeleteFilter(ctx, oldRecord)) {
            this.afterDelete(ctx, oldRecord, ctx.getQueriedRecordMap().get(oldRecord.Id));
          }
        }
      }
      when AFTER_UNDELETE {
        for (SObject newRecord : ctx.filteredRecords()) {
          if (this.afterUndeleteFilter(ctx, newRecord)) {
            this.afterUndelete(ctx, newRecord, ctx.getQueriedRecordMap().get(newRecord.Id));
          }
        }
      }
    }
  }
}
