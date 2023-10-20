trigger PrimaryContactPhoneUpdateTrigger on Contact (after update, after insert) {

    // Initialize lists and maps to store data for processing
    List<Contact> primaryContactsToUpdate = new List<Contact>();
    Map<Id, Id> accountToPrimaryContactMap = new Map<Id, Id>();

    // Loop through the new and updated contacts
    for (Contact updatedContact : Trigger.new) {
        if (updatedContact.Primary_Contact__c) {
            accountToPrimaryContactMap.put(updatedContact.AccountId, updatedContact.Id);
        }
    }

    // If there are primary contacts to process
    if (!accountToPrimaryContactMap.isEmpty()) {
        Set<Id> accountIds = accountToPrimaryContactMap.keySet();

        // Query for related contacts that are not marked as primary
        for (Contact relatedContact : [
            SELECT Id, AccountId, Primary_Contact_Phone__c
            FROM Contact
            WHERE AccountId IN :accountIds
            AND Id NOT IN :accountToPrimaryContactMap.values()
        ]) {
            Id primaryContactId = accountToPrimaryContactMap.get(relatedContact.AccountId);
            Contact primaryContact = Trigger.newMap.get(primaryContactId);

            relatedContact.Primary_Contact_Phone__c = primaryContact.Primary_Contact_Phone__c;
            primaryContactsToUpdate.add(relatedContact);
        }

        // Updates related contacts asynchronously with error handling
        if (!primaryContactsToUpdate.isEmpty()) {
            Database.SaveResult[] updateResults = Database.update(primaryContactsToUpdate, false);
            for (Database.SaveResult result : updateResults) {
                if (result.isSuccess()) {
                    // Success
                    System.debug('Contact updated successfully. Contact ID ' + result.getId());
                } else {
                    // Error
                    for (Database.Error err : result.getErrors()) {
                        System.debug('The following error occurred:');
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Contact fields affected by this error: ' + err.getFields());
                    }
                }
            }
        }
    }
}
