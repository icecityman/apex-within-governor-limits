trigger AccountTrigger on Account (after update) {
    if(Trigger.isAfter) {
        if (Trigger.isUpdate) {
           CreateChatterPostHotAccount.afterUpdate(Trigger.new);
        }
    }
}