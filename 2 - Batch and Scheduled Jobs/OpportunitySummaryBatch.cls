global class OpportunitySummaryBatch implements Database.Batchable<sObject> {
    Map<Id, List<Opportunity>> resultsMap = new Map<Id, List<Opportunity>>();

    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('SELECT AccountId, Amount, StageName FROM Opportunity WHERE CreatedDate = THIS_MONTH');
    }

    global void execute(Database.BatchableContext context, List<Opportunity> scope) {
        for (Opportunity opp : scope) {
            if (!resultsMap.containsKey(opp.AccountId)) {
                resultsMap.put(opp.AccountId, new List<Opportunity>());
            }
            resultsMap.get(opp.AccountId).add(opp);
        }
    }
   global void finish(Database.BatchableContext context) {
    List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

    for (Id accountId : resultsMap.keySet()) {
        Account acc = [SELECT Name, Owner.Email FROM Account WHERE Id = :accountId LIMIT 1];
        
      
        // Select Templete
        EmailTemplate emailTemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'testBatch'];

       
        // Create New Email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTemplateId(emailTemplate.Id);
        email.setTargetObjectId(acc.Id);

        emailList.add(email);
    }

    // Debug Track Information
    System.debug('N. Email on list: ' + emailList.size());

    // Send Email
    Messaging.sendEmail(emailList);
}


}
