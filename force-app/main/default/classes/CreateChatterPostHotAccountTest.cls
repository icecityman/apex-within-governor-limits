@IsTest
private class CreateChatterPostHotAccountTest {
   @IsTest
   static void newPostHotAccount() { 
   
        //Create a cold account record. 
        Account hotAccnt = new Account( 
            Name = 'Cold test account', 
            Rating = 'Cold' 
        );  
        insert hotAccnt;   

        List<Account> lsAccnt = [
            SELECT Id, Name, Rating 
            FROM Account 
            WHERE Id = :hotAccnt.Id
        ];
        System.assertEquals(1, lsAccnt.size(), 'Cold account found');
        System.assertEquals('Cold test account', hotAccnt.Name, 'Couldn\t find the cold account.'); 
        System.debug('Confirmed cold test account is created');
        
        //Create a collaboration group.
        CollaborationGroup colgrp = new CollaborationGroup (
            Name = 'Hot Accounts', 
            CollaborationType  = 'Public'
        );
        insert colgrp;

        System.assertEquals('Hot Accounts', colgrp.Name, 'Couldn\t find the collaboration group named Hot Accounts.'); 
        System.assertEquals('Public', colgrp.CollaborationType, 'The collaboration group was not Public.');
        System.debug('Confirmed collaboration group is created');
        
        //Create a chatter post. 
        List<FeedItem> post = new List<FeedItem>();
        String status = hotAccnt.Id + ' ' + hotAccnt.Name + 'This account is HOT!';
        FeedItem msg = new FeedItem (
            ParentId = colgrp.Id, 
            Title = hotAccnt.Name, 
            Body = status
        ); 
        
        Test.startTest();
        hotAccnt.Rating = 'Hot';  
        update hotAccnt; 
        post.add(msg);  
        insert post;
        system.debug('Get org limits: ' +  Limits.getLimitDmlRows());
        Test.stopTest();

        List<FeedItem> hotMsg = [ 
            SELECT Id, Body 
            FROM FeedItem 
            WHERE Title = :hotAccnt.Name 
            AND ParentId = :colgrp.Id AND Id = :msg.Id
        ];
        System.assertEquals('Hot', hotAccnt.Rating, 'Couldn\t confirm the account rating is hot.');
        System.debug('Confirmed account is now hot');
        
        System.assertEquals( 1, hotMsg.size(), 'Message is found.' );  
        System.assertEquals( msg.Body, hotMsg[0].Body, 'Body of message is accurate.' ); 
    }
}