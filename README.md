# Due to Time Constraints #
20170711@1715
This project is moving fast and by nature it must;(_Chiefly Swift and Production Deadlines_) So I am about to go off of the rails and introduce more Untested Code. That will be this new branch 04-EditControllers
SIDEBAR:: The previous build was chiefly a test of struts, and base implementations. If I require in one context, Two of One Type and at least one of another (with a 1:many relationship) then that has to be built in. Also I am scrapping hexID for a UUID
So I have to start with views and then viewControllers

# Adding DataControllers #
20170627@1200
Well I do know that it works. _BUT_ in the Cocoa version I do not use the entity in the view. it is conceptually the job of the people controller to service that request and publish the result. So to follow that I will need to bypass a lot of the good methods in the person controller.