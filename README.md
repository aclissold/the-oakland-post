Now available on the App Store! [Check it out](https://appsto.re/us/5geG3.i)!

The Oakland Post App
====================

The mobile companion for [The Oakland Post](http://www.oaklandpostonline.com)'s
website, written entirely in Swift!

Screenshots
-----------
![Screenshot 1](https://raw.githubusercontent.com/aclissold/The-Oakland-Post/master/The%20Oakland%20Post/Screenshots/Screenshot%201.png)

![Screenshot 2](https://raw.githubusercontent.com/aclissold/The-Oakland-Post/master/The%20Oakland%20Post/Screenshots/Screenshot%202.png)

![Screenshot 3](https://raw.githubusercontent.com/aclissold/The-Oakland-Post/master/The%20Oakland%20Post/Screenshots/Screenshot%203.png)

Compiling
---------

Just clone, open `TheOaklandPost.xcworkspace`, and build & run. A CocoaPods
installation is not necessary since the dependencies are vendored in
`Pods/`.

Conventions
-----------

### Issues
Each issue is assigned exactly three labels of the form
**(severity, type, component)**:

    severity  = major | minor .
    type      = bug | enhancement | feature .
    component = global | home | sections | photos | blogs | info | login .

### Commit Messages
I follow the recommendations from the [Git book], e.g.

`Home: heighten rows and add placeholder date label`

[Git book]: http://git-scm.com/book/en/Distributed-Git-Contributing-to-a-Project#Commit-Guidelines
