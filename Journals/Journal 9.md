Journal 9

With the app coming to a close, for this week I focused on 4 coding details- storing user data, hiding the main screen, getting the home button to bring up the main segue screen, and getting the camera to toggle. Saving user data was definitely the hardest part I had to figure out so far. When looking it up online, there are a lot of examples on saving settings/preferences or strings, but I needed a way to save an object into an array. I tried a bunch of different things from stack overflow but nothing was working. Eventually I got it work, I understand it but it was a lot of trial and error and mixing of online resources. I had to change my Constants file a bit because it was also hard to work with the way I had set it up and with CLLocationCoordinate2D. So, I took that out and reorganized. 

Hiding the main screen ended up being easier then I thought once I googled it the right way and same with the home button. I also fixed the picker options showing up on the add location page, I just needed to resign the responder. 

The last thing I got was to turn the camera on and off. The only issue left with that is you can turn it on and off but then not on again. I believe it is because I have a session up and running and when I try to start a new one again, they're "competing." I'm not sure yet how to stop the previous session and "erase" it so that a new one can start up again. But for now I am content with the fact I can get it off once it's on.

So with that I just need to update my video tutorial with these new changes and then finalize my poster for Thursday. 