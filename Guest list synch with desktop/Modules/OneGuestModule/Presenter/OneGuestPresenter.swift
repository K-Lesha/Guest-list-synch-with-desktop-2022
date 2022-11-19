//
//  OneGuestPresenter.swift
//  Guest list synch with desktop
//
//  Created by Алексей Коваленко on 14.11.2022.
//

import Foundation

protocol OneGuestPresenterProtocol {
    // VIPER protocol
    var view: OneGuestViewPortocol! {get set}
    var interactor: OneGuestInteractorProtocol! {get set}
    var router: RouterProtocol! {get set}
    // Init
    init(view: OneGuestViewPortocol, interactor: OneGuestInteractorProtocol, router: RouterProtocol, guest: GuestEntity, eventID: String)
    // Properties
    var guest: GuestEntity! {get set}
    var eventID: String!  {get set}
    // Guest check-in/out methods
    func oneGuestEntered(completion: @escaping (String) -> ())
    func canselAllTheGuestCheckins(completion: @escaping (String) -> ())
    // Gift methods
    func presentOneGift(completion: @escaping (String) -> ())
    func ungiftAllTheGifts(completion: @escaping (String) -> ())
    // Other methods
    func updateGuestData(completion: @escaping (Result<GuestEntity, SheetsError>) -> ())
    func setGuestPhoto(stringURL: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
    //Navigation methods
    func showGuestEditModule()
}

class OneGuestPresenter: OneGuestPresenterProtocol {
    //MARK: -VIPER PROTOCOL
    weak var view: OneGuestViewPortocol!
    var interactor: OneGuestInteractorProtocol!
    var router: RouterProtocol!
    //MARK: -INIT

    required init(view: OneGuestViewPortocol, interactor: OneGuestInteractorProtocol, router: RouterProtocol, guest: GuestEntity, eventID: String) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.guest = guest
        self.eventID = eventID
    }
    //MARK: -Properties
    var guest: GuestEntity!
    var eventID: String!
    
    //MARK: -METHODS
    //MARK: Guest check-in/out methods
    func oneGuestEntered(completion: @escaping (String) -> ()) {
        interactor.oneGuestEntered(eventID: self.eventID, guest: self.guest, completion: completion)
    }
    func canselAllTheGuestCheckins(completion: @escaping (String) -> ()) {
        interactor.canselAllTheGuestCheckins(eventID: self.eventID, guest: self.guest, completion: completion)
    }
    //MARK: Gift methods
    func presentOneGift(completion: @escaping (String) -> ()) {
        interactor.presentOneGift(eventID: self.eventID, guest: self.guest, completion: completion)
    }
    func ungiftAllTheGifts(completion: @escaping (String) -> ()) {
        interactor.ungiftAllTheGifts(eventID: self.eventID, guest: self.guest, completion: completion)
    }
    //MARK: Other methods
    func setGuestPhoto(stringURL: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        interactor.setGuestPhoto(stringURL: stringURL, completion: completion)
    }
    func updateGuestData(completion: @escaping (Result<GuestEntity, SheetsError>) -> ()) {
        interactor.updateGuestData(eventID: self.eventID, guest: self.guest, completion: completion)
    }
    //MARK: Navigation methods
    func showGuestEditModule() {
        router.showAddModifyGuestModule(state: .modifyGuest, guest: self.guest, eventID: self.eventID)
    }
}
