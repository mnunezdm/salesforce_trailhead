global class WarehouseSyncSchedule implements Schedulable {
    private static final String DAILY_CRON = '0 0 1 ? * * *';

    // implement scheduled code here
    global void execute(SchedulableContext ctx) {
        System.debug('Running Warehouse Equipment Sync at ' + System.now());
        WarehouseCalloutService.runWarehouseEquipmentSync();
    }

    public static String schedule() {
        WarehouseSyncSchedule warehouseSchedule = new WarehouseSyncSchedule();
        // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        String jobID = System.schedule('Warehouse Syncronization', DAILY_CRON, warehouseSchedule);

        System.debug('Scheduling class was succesfull, jobId: ' + jobID);
        return jobID;
    }
}