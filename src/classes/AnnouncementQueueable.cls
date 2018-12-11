/**
 * @name AnnouncementQueueable
 * @description This class posts Chatter Announcements
**/
public class AnnouncementQueueable implements Queueable {

    private List<ConnectApi.AnnouncementInput> toPost;

    public AnnouncementQueueable(List<ConnectApi.AnnouncementInput> toPost) {
        this.toPost = toPost;
    }

    public void execute(QueueableContext context) {
        for (ConnectApi.AnnouncementInput input : toPost) {
            postAnnouncements(toPost);
        }
    }

    /**
     * @name postAnnouncements
     * @description This method is provided for you to facilitate the Super Badge
    **/
    public static void postAnnouncements(List<ConnectApi.AnnouncementInput> announcements){
        while (announcements.size() > 0){
            if (Limits.getDMLStatements() < Limits.getLimitDMLStatements() && !test.isRunningTest()){
                ConnectApi.AnnouncementInput a = announcements.remove(0);
                ConnectApi.Announcements.postAnnouncement('Internal', a);
            } else {
                System.debug(LoggingLevel.DEBUG, 'Limit almost reached, enqueueing job in order to complete');
                break;
            }
        }
        if (announcements.size() > 0 && !test.isRunningTest()){
            AnnouncementQueueable q = new AnnouncementQueueable(announcements);
            System.enqueueJob(q);
        }
    }

}