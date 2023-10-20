global class OpportunitySummaryScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Runs the batch class
        OpportunitySummaryBatch batch = new OpportunitySummaryBatch();
        Database.executeBatch(batch);
    }
}
