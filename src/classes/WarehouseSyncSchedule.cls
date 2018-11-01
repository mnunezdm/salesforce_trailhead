global class WarehouseSyncSchedule implements Schedulable {
  // implement scheduled code here
    global void execute(SchedulableContext ctx) {
        System.debug('Running Warehouse Equipment Sync at ' + System.now());
        WarehouseCalloutService.runWarehouseEquipmentSync();
    }

    public static void schedule() {
        WarehouseSyncSchedule warehouseSchedule = new WarehouseSyncSchedule();
        // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        String cronExpression = '0 0 1 ? * * *';
        String jobID = System.schedule('Warehouse Syncronization', cronExpression, warehouseSchedule);

        System.debug('Scheduling class was succesfull, jobId: ' + jobID);
    }
}