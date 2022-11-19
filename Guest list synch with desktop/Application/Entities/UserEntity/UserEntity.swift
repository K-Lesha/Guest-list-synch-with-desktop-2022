//
//  UserEntity.swift
//  Guest list synch with desktop
//
//  Created by Алексей Коваленко on 28.10.2022.
//

import Foundation


enum UserTypes: Int {
    case organizer = 0 // can create events and manage them, can create guestlists and manage them, can see other organizer events
    case hostess = 1 // can see events by organizer, cant create own events, can manage guestlist
    case client = 2 // can see events by organizer, cant create own events, can manage guestlist
    
    static var count: Int {
        return UserTypes.client.rawValue + 1
    }
    var description: String {
        switch self {
        case .organizer: return "Организатор или со-организатор"
        case .hostess: return "Хостесс"
        case .client: return "Клиент"
        }
    }
}

struct UserEntity {
    var uid: String
    var payedEvents: Int
    var eventsIdList: [String]
    var delegatedEventIdList: [String]?
    var accessLevel: UserTypes
    var coorganizers: [SupportingUserEntity]?
    var headOrganizers: [SupportingUserEntity]?
    var hostesses: [SupportingUserEntity]?
    var name: String
    var surname: String?
    var email: String
    var active: Bool
    var agency: String?
    var avatarLinkString: String?
    var registrationDate: String
    var signInProvider: String
    
    static func createUserEntityWithData(usersDictionary: NSDictionary?, userUID: String) -> UserEntity {
        let userData = usersDictionary?.object(forKey: userUID) as? NSDictionary
        // find all the userData in Snapshot
        let payedEvents = userData?.object(forKey: "payedEvents") as! Int
        var eventsIdList = Array<String>()
        if let eventsIdListFromDatabase = userData?.object(forKey: "eventsIdList") as? Array<String> {
            eventsIdList = eventsIdListFromDatabase
        }
        let accessLevelString = userData?.object(forKey: "userTypeRawValue") as! String
        let accessLevelInt: Int = Int(accessLevelString) ?? 4
        let accessLevel = UserTypes(rawValue: accessLevelInt)!
        let coorganizersUIDs = (userData?.object(forKey: "coorganizersUIDs") as? [String])
        let coorganizers = UserEntity.initSupportingUsers(uids: coorganizersUIDs)
        let headOrganizersUIDs = userData?.object(forKey: "headOrganizersUIDs") as? [String]
        let headOrganizers = UserEntity.initSupportingUsers(uids: headOrganizersUIDs)
        let hostessesUIDs = userData?.object(forKey: "hostessesUIDs") as? [String]
        let hostesses = UserEntity.initSupportingUsers(uids: hostessesUIDs)
        
        let delegatedEventIdList = UserEntity.initDelegatedEvents(users: [coorganizers, headOrganizers, hostesses])
        
        let name = userData?.object(forKey: "name") as! String
        let surname = userData?.object(forKey: "surname") as! String
        let email = userData?.object(forKey: "email") as! String
        let active = userData?.object(forKey: "active") as! String
        let agency = userData?.object(forKey: "agency") as! String
        let avatarLinkString = userData?.object(forKey: "avatarLinkString") as! String
        let registrationDate = userData?.object(forKey: "registrationDate") as! String
        let signInProvider = userData?.object(forKey: "signInProvider") as! String
        //create the userEntity
        let user = UserEntity(uid: userUID,
                              payedEvents: payedEvents,
                              eventsIdList: eventsIdList,
                              delegatedEventIdList: delegatedEventIdList,
                              accessLevel: accessLevel,
                              coorganizers: coorganizers,
                              headOrganizers: headOrganizers,
                              hostesses: hostesses,
                              name: name,
                              surname: surname,
                              email: email,
                              active: active.bool!,
                              agency: agency,
                              avatarLinkString: avatarLinkString,
                              registrationDate: registrationDate,
                              signInProvider: signInProvider)
        return user
    }
    
    static func initSupportingUsers(uids: [String]?) -> [SupportingUserEntity]? {
        return nil
    }
    static func initDelegatedEvents(users: [[SupportingUserEntity]?]) -> [String]? {
        return nil
    }

    
    
}
