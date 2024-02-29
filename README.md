# Camera-Filters
Camera filters and add text functionality with sharing on social media option.

Steps to run the application:
1. Create xcode project by giving any name.
2. In project target, in Signing & Capabilities add your team and bundle identifier.
3. Right click on Info.plist & select Open As -> Source code
4. Add below code after the end of UIApplicationSceneManifest dict or you can directly replace your Info.plist file with the one present in this project:
    <key>NSCameraUsageDescription</key>
    <string>Please allow access to take a picture</string>
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>Please allow access to save photo in your photo library</string>
5. Add/Replace files in your project with all the files present in this project such as FilterModel, ViewController, SecondViewController, Main.storyboard and LaunchScreen.storyboard.
6. Add image files in your assets from the assets present in this project.
7. Build your project.
8. After it is successfully built, you are ready to run the application.


Functionality:
1. After the app is launched, you will see "Take a photo" button. Click on that.
2. Camera will open.
3. Click a photo and then click on Use photo.
4. Photo will be displayed on screen and "Edit button" will be visible. Click on that. You will be moved to next screen.
5. In this, you can apply filters to the image, add text on image and after changes you can reset the image to original image.
6. Once changes are done, "Save" button at the top right corner will be enabled.
7. Click on "Save" button to save the image in your photo library else you can go back to previous screen by clicking on "Back" button.
8. Once image is saved, you will come back to previous screen and an alert will show mentioning the same.
9. If saving is failed, then also alert will be shown for the error occurred.
10. On the previous screen i.e first screen, saved image will be displyed and now "Share" button at the top right corner will be enabled.
11. On clicking share button, a pop up will be shown where various options will be displayed to share the image e.g. social media apps which are already installed in the phone like facebook, instagram, etc.
12. You can share the image anywhere you want.
13. Also from here as well you can save the image in the photo library.
