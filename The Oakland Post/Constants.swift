//
//  Constants.swift
//  The Oakland Post
//
//  Global constants.
//
//  Created by Andrew Clissold on 6/13/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

import UIKit

// Theming
let serifName = "Palatino-Roman"
let sansSerifName = "AvenirNext-Medium"
let boldSansSerifName = "AvenirNext-DemiBold"
let oaklandPostBlue = UIColor(
    red: 115.0/255.0, green: 148.0/255.0, blue: 175.0/255.0, alpha: 1.0
)
let translucentToolbarWhite: CGFloat = 0.96

let tableViewHeaderHeight: CGFloat = 80
let tableViewRowHeight: CGFloat = 120
let topToolbarHeight: CGFloat = 64, bottomToolbarHeight: CGFloat = 44

// NSNotificationCenter
let foundStarredPostsNotification = "foundStarredPosts"

// For ShowAlertForErrorCode.swift
let feedParserDidFailErrorCode = 0

// UITableViewCell identifiers
let cellID = "cell", sectionsCellID = "sectionsCell"
let photoCellID = "photoCell", favoritesHeaderViewID = "favoritesHeaderView"

// Segue identifiers
let readPostID = "readPost", showSectionID = "showSection", signUpID = "signUp"
let logInID = "logIn", favoritesID = "favoritesViewController", searchResultsID = "searchResultsViewController"
let biosID1 = "bios1", biosID2 = "bios2", biosID3 = "bios3"

// Restoration identifiers
let infoContentViewControllerID = "infoContentViewController"
