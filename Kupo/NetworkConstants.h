//
//  NetworkConstants.h
//  Kupo
//
//  Created by Peter Shih on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// HTTP Terms
#define GET @"GET"
#define POST @"POST"
#define PUT @"PUT"
#define DELETE @"DELETE"

// API Version
#define KUPO_API_VERSION @"v1"

// If this is defined, we will hit the staging server instead of prod
// #define STAGING

#if TARGET_IPHONE_SIMULATOR
  #define STAGING
  #define USE_LOCALHOST
#endif

#ifdef STAGING
  #ifdef USE_LOCALHOST
    #define KUPO_BASE_URL [NSString stringWithFormat:@"http://localhost:3000/%@", KUPO_API_VERSION]
  #else
    #define KUPO_BASE_URL [NSString stringWithFormat:@"http://scrapboard.co/%@", KUPO_API_VERSION]
  #endif
#else
  #define KUPO_BASE_URL [NSString stringWithFormat:@"http://scrapboard.co/%@", KUPO_API_VERSION]
#endif

#define S3_PHOTOS_URL @"http://s3.amazonaws.com/scrapboard/kupos/photos"
#define S3_VIDEOS_URL @"http://s3.amazonaws.com/scrapboard/kupos/videos"

// Seven Minute Apps
#define KUPO_TERMS_URL @"http://www.sevenminuteapps.com/terms"
#define KUPO_PRIVACY_URL @"http://www.sevenminuteapps.com/privacy"

// Facebook
#define FB_AUTHORIZE_URL @"https://m.facebook.com/dialog/oauth"
#define FB_GRAPH_FRIENDS @"https://graph.facebook.com/me/friends"
#define FB_GRAPH_ME @"https://graph.facebook.com/me"

// #define FB_PERMISSIONS [NSArray arrayWithObjects:@"offline_access",@"user_photos",@"friends_photos",@"user_education_history",@"friends_education_history",@"user_work_history",@"friends_work_history",nil]

// #define FB_EXPIRE_TOKEN // if defined, will send a request to FB to expire a user's token

// Unused, FB doesn't seem to return these
// interested_in
// meeting_for