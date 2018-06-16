# KevCodex

# Basic Server Side Swift Project #

This is a basic server-side Perfect, Swift written project to display, save, and delete information related to my favorite games. The information is saved on mongoDB. The deployed web viewer to add and delete is hosted on my local home server at the domain [KevCodex](https://kevcodex.com/) (I don't leave the server on 24/7 to save $$$). The partner iOS app that retrieves data from this web server is here [iOS Partner](https://github.com/kirby10023/DemoShowcaseProject)

***
## Getting Started ##
* Install MongoDB and Swift
* Clone this project
* `cd` into project directory
* Run Command `swift package generate-xcodeproj`
* Open Xcode Project
* Setup Environment Variables Name: `DB_URI`, Value: `mongodb://localhost:27017` (go to Edit Scheme -> Arguments) 
* Setup custom working directory to folder that contains webroot. E.g. `/Users/kirby/Documents/basicwebsite` (go to Edit Scheme -> Options -> Working Directory) 
* Change Active Scheme to `Run`
* Run MongoDB (Run Command `mongod`)
* Run the Xcode Project
* Navigate to `http://localhost:8080/` and you should see the web viewer

## Deploying ##
* To Be Written

## Requirements to Run Locally ##
* MongoDB 3.4+
* Swift 4.0+

## Requirements to Deploy ##
* AWS Console
* Docker

## Project Dependencies ##
* Perfect 2.0+
* MongoKitten 4.0+

## Adding dependencies ##
* To Be Written

## Improvements ##
* Make a base RouteController similar to what UIViewController does
* Have a Mongo Controller
* Have an static Response Code Error class
* Make a Game API rather than letting the Game model do all the saving/deleting
* Add more comments for explanations 
* Improvements to the web viewer
