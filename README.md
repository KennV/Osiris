# Due to Time Constraints #

20170726@1330

So I tok a moment to fully rewrite the GUI and it should work but it is not compatible with the given code that I am looking at; therefore I will need to add the following element Custom TableViewCell with a stack view that has a MKMapView and another stack view with three buttons. One for each available Seque: 
*But* Beyond that Will need to add a new Custom TableViewCell similar to the one for ratings that implements a MapvView with MKAnnotations, MapViewTableCell - - > AND

AND to do this I need to have the cells as "Dynamic Prototypes this broke everything. For obvious and fixable reasons - But the fun thing to fix and the item of note is that the size of the cells was the default, and the one that was visible was set to that size (along with my views and buttons) this is set in the insector for the TableView, Set all of the cells to 128 px and you can then set the custom for the other cells sizes to a "custom" 48 px. this is indeterminate because I cannot see these, IF IT DOES NOT WORK THEN I WILL HAVE TO SET THIS IN CODE [See also ~/Developer/02/Dev2/Alt/pub/Tricorder/Tricorder/Tricorder/Views/MapView/KVMapViewCon.swift/ and ~/Developer/../MapObjects/KVAnnotationItem.swift _AND_ /Users/Kenn/Developer/02/Dev2/Alt/pub/Tricorder/Tricorder/Tricorder/Views/PrimeTVC/tvcOBJ ]
~%@@1530
OK that starts a fairly good commit for the edit view controllers I really suppose the next step is to wire them up
 
Switch case for sectionHeight?

Add setupData()
OK that was not terrible. I wired up the two interfaces and then all of teh segues to empty views. And it works surprisingly well. Of course I may have issuse with Autolayout and Stacks but that is not impossible. SO I have the first half of Detail-Controllers and DataTests. That next bit is going to be a little bit more work
Add setupGUI()
Install custom views:
I like the work with the views but these custom sliders and junk will need to be a different type of view and I need to get to the Q&D of getting a map in a cell.
BUT also important is getting these views to init with a color palette in code. So that I can see the design and layout in HW

20170708@12:30
OK in its basic form I will need 3 sections in some table view
I already have a Peron/People/Owner and Vendor. So i Added
Sessions, and its parent controller.
Also sort of undocumented, I have it at about 50% test coverage. which
I really enjoy.

I am not sure what I will get in the DVC if I have no object. That is one reason to have a setup function. ~ ~ I will need just some basic logic to make a person if the array is empty when I delete the person - so the array cannot be empty. Next I have to see if Person<T> has types - - Nope that is in root so I will be testing if the item at people[0] is "Owner" or "Friend"
ACTUALLY if I think about it for a moment, I can hide this window and _only_ present the detail if the arrays are empty. Then in the detail I can set the state/isVisible on everything except a setupButton. This will pound through getting the data and setting owner. So Back to the _PDC Class
OK I have set the DetailView as top in the App Delegate. All I need to do is hide the UI and only have an setup button See. the Split view Tag in appDeli
Well I *Do* need to add a protocol here for the setup to init an owner and all that this entails, _BUT_ I do not need one per se for the regular<T> inits/save/load.


2017628@1200
OKizzely; I went into test. And had some fun. I cleaned up the interface and tested the longhand and short versions of makePerson:(). Well not deeply, not beyond the count of the array, I should be ready to add people to the pTVC

20170627@1200
The redo goes apace; I have the controllers and models lined up very nicely. and the classes are good. I had a strong fix with the inherritance tree Item and Entity were not Subs of OsirisData. All I really need to do is write out the tests.

20170711@1715
This project is moving fast and by nature it must;(_Chiefly Swift and Production Deadlines_) So I am about to go off of the rails and introduce more Untested Code. That will be this new branch 04-EditControllers
SIDEBAR:: The previous build was chiefly a test of struts, and base implementations. If I required in one context, Two of One Type and at least one of another (with a 1:many relationship) then that has to be built in. Also I am scrapping hexID for a UUID
## So I need to add the other required  libs ##

### then I should ###
So I have to start with views and then viewControllers

# Adding DataControllers #
20170627@1200
Well I do know that it works. _BUT_ in the Cocoa version I do not use the entity in the view. it is conceptually the job of the people controller to service that request and publish the result. So to follow that I will need to bypass a lot of the good methods in the person controller.

20170620@1345
See it is not that I can't do it in Cocoa. AAMOF I really would enjoy the challenge of doing it in C, Just not on this deadline.