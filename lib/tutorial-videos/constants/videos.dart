import 'package:kaddep_data_capture/tutorial-videos/tutorial-videos.dart';

class Videos{
  static const List<TutorialVideoModel> tutorialVideos = [
    TutorialVideoModel(
        id: "v-1",
        title: "User onboarding",
        description: "Different categories of users and how they are registered on the platform",
        videoAssetPath: VideoAssetConstants.userOnboarding,
    ),
    TutorialVideoModel(
      id: "v-2",
      title: "Login and App Overview",
        description: "How to login with your credentials, then we glance through different sections of the app",
        videoAssetPath: VideoAssetConstants.loginAndOverview,
    ),
    TutorialVideoModel(
      id: "v-3",
      title: "Setting Location of Interest",
        description: "Setting your location of interest, i.e. where you will be capturing data",
        videoAssetPath: VideoAssetConstants.settingLocation,
    ),
    TutorialVideoModel(
      id: "v-4",
      title: "Verifying/Updating an Existing Record",
        description: "Using a candidate's bvn to search their records, update missing or incorrect details and verify their business",
        videoAssetPath: VideoAssetConstants.verifyingExistingRecord,
    ),
    TutorialVideoModel(
      id: "v-5",
      title: "Enrolling a New Candidate",
        description: "You may enrol new candidates by entering their full information on the form",
        videoAssetPath: VideoAssetConstants.enteringNewRecord,
    ),
    TutorialVideoModel(
      id: "v-6",
      title: "Records Synchronization",
        description: "Video tutorial showing how to upload your local records to the server",
        videoAssetPath: VideoAssetConstants.synchronization,
    ),

  ];
}