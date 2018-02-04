Destiny Item Comparisons
========================

Before I begin, _"Yes, I know the name of this repo does not reflect the intentions of the project!"_. This is a personal project, not meant for mass consumption. Plus, No ones going to look at it anyway. Then again, without access to my database.... nothing here will really work, so... yeah. _Sticks out Tongue_ Soon, I will remove this and start-over so...

## Purpose
The purpose of this project was, first and foremost, teach myself Ruby. Secondly, it was to devise a very high level way to determine what had changed with items between update to the Destiny the Game API.

## How it Works
Within the `./update_data.rb` file, you call what you want to update and what to compare. The way the file currently stands, it updates and compares against almost all item types _(weapons, armor, emblems, shaders, etc..)_.

Calling any of the methods queries a local MongoDB server and extracts the needed info from it. This is then simplified and the resulting data is placed into a csv file. 

When the API is updated, I pull down those updates into the Mongo and run these commands again, creating new files since the dates are different. I then compare the two files, pulling out new additions and place those in a new file with a like, `d2_new_Warlock_2018-02-04.csv`. This file will have the exact same format as the main file.

## How to Use
- Clone the repo
- cd into the repos directory
- `bundle install`
- create a `.env` file in the root of the project to store your MongoDB creds. The file located at `./app/db/connect.rb`, will allow you to configure how to connect to your MongoDB instance. It is currently configured for local access, but the commented sections will allow you to access most any other remote instances you might have. As always, consult your docs for more info on that.
- run `ruby update_data.rb`

If you plain to use the `update_item_sets` method, then do the following:
- Create a directory titled "data" in the root of your project.
- Inside that directory, create another in the format of the current date followed by '_update'. Ex: `2018-0-16_update`. 
- I haven't automated this yet... _work in the progress..._

You will find other files in the app directory. These actually have not been used in awhile and some of them are most likely me seeing if I can do something or isolate a problem. Others, might very well work just fine.

## Warnings
This repo is experimental. I repeat, this repo is experimental. It most likely does not contain any sort of best practices found within the Ruby community. That's sorta the point. Learn as I go. Use of this repo may case puppies to cry and some flowers to wither. 

## To Do List
- Automate item_set directory creation and writing.
- Create repo of older csv results. This will allow someone to pull in an update from two months ago and compare with a more recent update. 
- Allow for custom comparisons. Compare files from 3 months ago to files from 2 months ago. Currently, this is limited to comparing what historical data you currently have to todays date. Not the best in the world. 
- Since I'm still learning Ruby... Get Better! 