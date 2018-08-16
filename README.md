# Moovup
Moovup iOS Coding Assignment

### User Requirements Done
- Retrieving list of people from the API
- Displaying list of people.
- Showing details when user select an item in the list.
- Adding marker on the map based on the provided latitude/longitude in `location`. 

## Technical Requirements Done
- Source code is stored in a git repository github
- App will cache the API result and wikk be available offline
- Storyboard or XIB are not used, done programatically.

### Folder/File Structure
- AppDelegate - Initiates launch view controller.
- ViewController - Initiates People List APi, fetches data, load in the tablelist, cache the data for offline mode, oad data in offline mode.
- MUPersonDetailsController - Show mapview and annotaion popup at the given cordinates, shows person details.
- Reachability/MUReachability - Wrapper to Check for internet connectivity.
- APIManager/MUAPIManager - API class to connect the poeple list API.
- Model/MUPerson - Person data model to save and retrieve from datatbase.
- DataStore/MUDataStore - Data store class which performs data tasks to save and retrieve data models from database.
- DataStore/MUDBManager - Database class for save/retreive people data in sqlite.
- Libraries/UIView+Extensions - Uiview extensions for layout framing.
- Assets.xcassets - Assets used in the app.








