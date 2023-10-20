public class AccountController {
    public Account Account { get; private set; }
    public List<Contact> Contacts { get; private set; }
    public String contactName { get; set; }

    public AccountController(ApexPages.StandardController stdController) {
        this.Account = (Account)stdController.getRecord();
        this.Contacts = new List<Contact>();
        this.contactName = '';
        this.loadContacts();
    }

    public void loadContacts() {
        Contacts = [SELECT Id, Name, Title, Phone, Primary_Contact__c FROM Contact WHERE AccountId = :Account.Id];
    }

    public PageReference searchContacts() {
        Contacts = [SELECT Id, Name, Title, Phone, Primary_Contact__c FROM Contact WHERE AccountId = :Account.Id AND Name LIKE :('%' + contactName + '%')];
        return null;
    }
}