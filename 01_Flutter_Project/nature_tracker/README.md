# Nature Tracker

**A Blog App by Valerio**

**Project Focus:** Hardware and Sensors

---

## Introduction

I’ve attempted to build this blog app three times:

1. **Initial Attempt:** I started the app on my own but failed miserably. I struggled with basic navigation and could not get things working.
   
2. **Second Attempt:** I followed a Udemy tutorial to create an expense tracker and used that as a base for my blog app. However, the complexity of the project made it hard to manage, especially after a break.

3. **Current Attempt:** In my latest effort, I worked on a smart trash app as part of the POE project, which introduced me to Flutter. I decided to use the smart trash app as a template for my blog app to avoid starting from scratch.

---

## Coverage

The app should include the following features:

- **Add a Blog:** Create and add new blog entries.
- **Remove a Blog:** Delete existing blog entries.
- **Edit a Blog:** Modify blog entries.
- **Like Button:** Allow users to like blog entries.
- **Backend Integration:** Connect to a backend to save blog entries.
- **API Documentation:** Provide Swagger documentation for POST, DELETE, and PUT requests related to blog entries.

The app will also focus on hardware and sensors:

- **Camera:** For taking photos.
- **Movement Sensor:** To track steps.
- **Location Coordinates:** To log the location where each blog entry is created.
- **Barometer:** To measure atmospheric pressure and estimate altitude.
- **Microphone:** To capture audio, potentially for adding voice notes to blog entries.

---

## Why "Nature Tracker"?

The app is named "Nature Tracker" because it’s designed to let users create and manage blogs on the go. 
Users can start a new trip and add multiple blog entries throughout the journey. 
While walking, hiking, or engaging in other outdoor activities, users can capture photos, record audio, and add brief texts to save their experiences. 
By the end of the trip, they will have a collection of blog entries with photos and audio, documenting their journey in a convenient and organized way.

---

# 1 Setup
I cloned the Smart trash app and updated the whole GUI. I could not yet decide on what colors i want to use so i kept them for now.
I then changed the application so i could use it as a blog app.
It took me longer than expected to rebuild this but after i was done with this i was quite happy.
now I can create new adventures and add multiple Blogs to it. 
 - Side Note: I forgot to push this version to the Git hub repository. 
 
# 2 Hardware Implemenations

I implemented the Camera with  the help of the ImagePicker.dart
To make this work i had to decide on which platform i wanted to run the applicaiton. 
Since i have the Android emulator and own an Android myself i wanted to prioritize this platform.
I did enticipate to create an working IOs version aswell thats why i changed the "INFO.plist" aswell to acknowledge the permissions.

During this working period I also implemented a Sidebar with a Dummy login Screen. It doesnt work yet but it already look acceptable.

Second Sensor i wanted to integrate was teh Pedometer. For now it only takes the total steps of the day and does not rly count them itself.
So on the Android Emulator it does not have any data but on my phone it works and it takes the current footsteps of the day.

# 3 Google Maps and Picture Imporvement

I improved the picture handling. now the Content is displayed much nicer with the picture worked in.
The Google Maps should also work but man thats complicated so i try to finish this in the next step.


# 4 Unsecure Login and user settings implemented.

There is now a Login which is not secure and every user has its user data. 
The Google Maps Implementation is not working but thats ok. I tried to implement a FireBase Backend and had to reinstall Flutter, Android Studio and almost everything else becuause i wasnt able to start the application anymore.. I took a very Wrong turn I think.
Well for now im happy with the progress. 
Tomorrow I will implement Hardware and Sensors: 
Hardware: Internet, batterylevel
Sensor: Ambient Light sensor for a Darkmode detection  and i keep working on the Step Counter.

# 5 Prettier
In this step i included the Logos and Colorschemes i prepared. now it looks already very good. I have to improve the Optics even more.
Especially the text inputs are not perfect yet.
Since the project is not on UI and graphics I should focus on what is really important.


# 6 Google Maps almost ruined me
Well as I said, I wanted to implement Google Maps. I was wondering why it didn't work. The code looked good but it had no connection to the Google API.
So easy said, easy done i connected the whole thing to google BUT WAIT. Thats not free. so up to a certain amount of usages you can use it for free but one wrong loop in the code and its bye bye Rolex.
So I as i am using OSMAND on my phone anyway and this is connected to OpenStreetMap i figured this should be an easy switch. Well, easy enough. So now i have a working Map.
Also I improved some more optics and the login and register screens are nicer now. 


# 7 Backend is Fun
Or so they told me. Since I have no idea how Quarkus works i use a RTDB from FireBase.
Now I implemented Post and Get with Futures. The Adventures work fine now. 
Tomorrow Ill implement the Blogs and hope i can put the two together the way it worked on local data.
A quick Summary on what works so far
- **Add a Blog:** Local yes
- **Remove a Blog:** Had it but removed it. have to implement this again
- **Edit a Blog:** Modification needs work. the Content cannot be modified
- **Like Button:** State of like is saved on the Blog. I have to connect the like to the User and not the Blog
- **Backend Integration:** Halfway there i hope
- **API Documentation:** Not yet started
--> Well looks like it needs work 

The app will also focus on hardware and sensors:

- **Camera:** *Implemented* and well displayed in the Blogs
- **Movement Sensor:** Takes current data from the Phone, not tracking
- **Location Coordinates:** *Implemented*. Well displayed with OpenStreetMap in the Blog
- **Barometer:** Not yet implemented, won't do
- **Battery:**	I replaced the Barometer with the Batterylevel recognition. *Implemented* In the Settings
- **Microphone:** Not Yet Implemented. Not sure if I will.


# 8 Backend User Login
The Userlogin works now as before. The Backend takes a lot of time.
The Content editing is activated again on the blogs and it PUTs the changed data to the backend.



# MD update

what can the app do?

A quick Summary on what works so far
- **Add a Blog:** implemented
- **Remove a Blog:** Had it but removed it. have to implement this again
- **Edit a Blog:** implemented
- **Like Button:** implemented
- **Backend Integration:** implemented
- **API Documentation:** canceled


The app will also focus on hardware and sensors:

- **Camera:** implemented
- **Movement Sensor:** implemented
- **Location Coordinates:** implemented
- **Barometer:** canceled
- **Battery:**	implemented
- **Microphone:** canceled


