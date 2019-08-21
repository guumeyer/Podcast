# MeyerPodcast
The MeyerPodcast is a podcast player, the user can search for a podcast and play the episodes by streaming or from offline.

### Prerequisites

What things you need to install the software and how to install them

Xcode 10.2+

Swift 5.0

iOS 10.0+

### Installing

```
git clone https://github.com/guumeyer/Podcast.git 
cd Podcast
```

And By terminal 
```
open Podcast.xcodeproj
```

or from the Xcode open the file `Podcast.xcodeproj`

## Overview

The app has a main tab bar with four view controller and shared player view will appear above the navigation bar.

	• The favorite podcasts - allows the user quick access the favorite podcast.
	• The search podcasts - allows the user to search the podcast and navigation on episodes. 
	• The episodes feed - allows the user see all podcast’s episodes, add the episode in the favorites, play the episode by streaming and download the episode.
	• The download manager - allows the user to play the podcast offline and manager the download.
	• The player view - allows the user to control audio player. The audio player allows user to use the control remote 

### The favorite podcasts
When the app first starts will open the favorites view. Users will be able to see and select a podcast to access the episodes feeds. 
Long tapping the user can remove the podcast after to confirm the deleting operations.

### The search podcasts
The user can access the search view by search item in the tab bar. The user can type the podcast name in the search field. The search will be dispatch after fill milliseconds to avoid unnecessary API request.
After the user type the term in search field  the App will make a API call to get the podcasts and display in the UI.
The user can select a podcast and access the episodes feed.

### The episodes feed
The episodes feed view will list all the episodes available to be played, the user the hit the button “Add favorites”  to quickly access from favorites view.
In the episode cell the user can swipe to left and hit the “Download” option to play the episode offline. 
When the user select an episode the player view will play the episode by stream. 

### The download manager
The user can access the download view by download item in the tab bar.  The download will displayed all offline episodes and during the download  the use can see the progress of the download. During the episode download  if the user select the episode the app will display some option like “Play by stream URL, Pause download, Cancel download and Resume Download”.  After the episode download finished the user can play the audio offline.

### The share player view
In the player view user can control the audio in the  App or from the iOS Remote control from the Apple Watch or Car play.  

## Technical features:
	• Use iTunes API to search the podcasts
	• Use URLSession to manager all API request and download audio and image in background
	• Cache images until 500mb
	• Use Decodable to parse JSON and XMLParse to parse the iTunes feed
	• Core Data to persistent the favorites podcasts and episodes download
	• The podcast files are storing in the local file system.
	• The navigation are composed by a main tab bar and three navigation bar for the Favorites, The Search and The Downloads scenes.
	• Audio Remote control by iOS remote control when the app is in background mode, by Apple watch and Car play.
  
  ## Authors
* **Gustavo Meyer** - *Initial work* - [Git](https://github.com/guumeyer)
