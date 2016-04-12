//
//  TrackingService.swift
//  locator
//
//  Created by Michael Knoch on 12/04/16.
//  Copyright © 2016 Locator. All rights reserved.
//

import Foundation
import Mixpanel

class TrackingService {

    static var mixpanel = Mixpanel.sharedInstanceWithToken("0ae5852e575b8e0b44fb3dc5370b2c94")
    
    static func trackEvent(event: String) {
         mixpanel.track(event);
    }
    
    static func setIdentity(id: String, name: String, mail: String) {
        mixpanel.identify(id);
        mixpanel.people.set(["$email": mail, "$name": name]);
    }
    
}
