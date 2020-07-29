//Post chatter message on a specific group with account information when specific criteria on an Account is met.
public class CreateChatterPostHotAccount {
    public static void afterUpdate(List<Account> updatedAccnts) { 
        //Create an empty list to store the chatter posts temporarily. 
        List<FeedItem> posts = new List<FeedItem>();
        
        //Identify the chatter group where the post will be made
        List<CollaborationGroup> chatterGroup = [
            SELECT Id 
            FROM CollaborationGroup 
            WHERE Name = 'Hot Accounts' 
            LIMIT 1
        ]; 
        
        //Iterate over the accounts, post chatter message with accnt info. 
        if (!chatterGroup.isEmpty()) {
            for (Account acct : [
                    SELECT Id, Name FROM Account 
                    WHERE Id IN :updatedAccnts and Rating = 'Hot']) {
                String status = acct.Id + ' ' + acct.Name + ' This Account is HOT! ';
                FeedItem msg = new FeedItem(
                    ParentId = chatterGroup[0].Id,
                	Title = acct.Name,
                	Body = status
                	);
                posts.add(msg);                         
            }
            insert posts;
        }
    }
}