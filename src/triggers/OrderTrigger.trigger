/**
 * @name OrderTrigger
 * @description
**/
trigger OrderTrigger on Order (after update) {
    OrderHelper.afterUpdate(Trigger.new, Trigger.old);
}