//Post chatter message on a specific group with account information when 
//specific criteria on an Account is met.
public without sharing class CreateChatterPostHotAccount {

    public static void afterUpdate(List<Account> updatedAccnts) {

        //Create an empty list to store the chatter posts temporarily. 
        List<FeedItem> posts = new List<FeedItem>(); 
        
        //Iterate over the accounts, post chatter message with accnt info. 
        for (Account acct : updatedAccnts) { 
            CollaborationGroup chatterGroup = [
                SELECT Id 
                FROM CollaborationGroup 
                WHERE Id = '0F96g000000hkTiCAI'
            ];
            String status = acct.Id + ' ' + acct.Name + ' This Account is HOT! ';
            FeedItem msg = new FeedItem(
                ParentId = chatterGroup.Id,
                Title = acct.Name,
                Body = status
            );
            posts.add(msg);
            insert posts;
        }
    }
}
