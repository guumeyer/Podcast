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
	• The share player view - allows the user to control audio player. 

### The favorite podcasts

### The search podcasts

### The episodes feed

### The download manager

### The share player view

## Technical features:
	• Use iTunes API to search the podcasts
	• Use URLSession to manager all API request and download audio and image in background
	• Cache images until 500mb
	• Use Decodable to parse JSON and XMLParse to parse the iTunes feed
	• Core Data to persistent the favorites podcasts and episodes download
	• The podcast files are storing in the local file system.
	• The navigation are composed by a main tab bar and three navigation bar for the Favorites, The Search and The Downloads scenes.
  
  ## Authors
* **Gustavo Meyer** - *Initial work* - [Git](https://github.com/guumeyer)
