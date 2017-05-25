//
//  PassGenerator.swift
//  AmusementParkPassGenerator
//
//  Created by Leticia Rodriguez on 5/23/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//

import UIKit

enum GuestType {
    case classic
    case vip
    case freeChild
}

enum EmployeeType {
    case foodServices
    case rideServices
    case maintenance
    case manager
    
}

// Area Access Types

enum AreaAccess {
    case amusementAreas
    case kitchenAreas
    case rideControlAreas
    case maintenanceAreas
    case officeAreas
}

// Ride Access Types

enum RideAccess {
    case allRides
    case skipAllRideLines
    
}

// Discount Access

enum DiscountAccess {
    case onFood(percentage: Double)
    case onMarchandise(percentage: Double)
    
    //
    static func == (left: DiscountAccess, right: DiscountAccess) -> Bool {
        
        switch (left, right) {
        case (let .onFood(percentage1), let .onFood(percentage2)):
            return percentage1 == percentage2
            
        case (let .onMarchandise(percentage1), let .onMarchandise(percentage2)):
            return percentage1 == percentage2

            default: return false // Cover all cases
            }
        }
    }

// Errors

enum EntrantDataError: Error {
    case missingBirthday(description: String)
    case missingName(description: String)
    case missingLastName(description: String)
    case missingStreetAddress(description: String)
    case missingCity(description: String)
    case missingState(description: String)
    case missingZipCode(description: String)
    case overFiveYearsOldError(description: String)
    
}

//
enum Permission {
    case granted(description: String)
    case denied(description: String)
}

//

struct Access {
    var areaAccess: [AreaAccess]? = Array()
    var rideAccess: [RideAccess]? = Array()
    var discountAccess: [DiscountAccess]? = Array()
    
    init(){
    }
    
    init(areaAccess: [AreaAccess]?,rideAccess: [RideAccess]?,discountAccess: [DiscountAccess]? ) {
        self.areaAccess = areaAccess
        self.rideAccess = rideAccess
        self.discountAccess = discountAccess
        
    }

}

class Employee {
    let firstName: String
    let lastName: String
    let streetAddress: String
    let city: String
    let state: String
    let zipCode: String
    let socialSecurityNumber: String?
    let dateOfBirth: Date?
    let type: EmployeeType
    
    
    
    init(firstName: String, lastName: String, streetAddress:String, city:String, state: String, zipCode:String, socialSecurityNumber:String?, dateOfBirth: Date?, type: EmployeeType) throws {
        
        if firstName == "" {
            throw EntrantDataError.missingName(description: "Employee name is required")
            
        }
        
        if lastName == ""  {
            throw EntrantDataError.missingLastName(description: "Employee lastname is required")
            
        }

        if streetAddress == ""  {
            throw EntrantDataError.missingStreetAddress(description: "Employee Street Address is required")
            
        }
        if city == ""  {
            throw EntrantDataError.missingCity(description: "Employee city is required")
            
        }
        if state == ""  {
            throw EntrantDataError.missingState(description: "Employee state is required")
            
        }
        if zipCode == ""  {
            throw EntrantDataError.missingZipCode(description: "Employee zipcode is required")
            
        }

        self.firstName = firstName
        self.lastName = lastName
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.socialSecurityNumber = socialSecurityNumber
        self.dateOfBirth = dateOfBirth
        self.type = type
        
    }
    
    
}

class HourlyEmployee: Employee, Accessable, Swipeable {
    var access: Access
    
    override init(firstName: String, lastName: String, streetAddress:String, city:String, state: String, zipCode:String, socialSecurityNumber:String?, dateOfBirth: Date?, type: EmployeeType) throws {
        access = Access(areaAccess: [],rideAccess: [],discountAccess: [])
        try super.init(firstName: firstName, lastName: lastName, streetAddress: streetAddress, city: city, state: state, zipCode: zipCode, socialSecurityNumber: socialSecurityNumber, dateOfBirth: dateOfBirth, type: type)
        
        }
 
    func generateAccessByEntrantType() -> Access {
        var areaAccessArray: [AreaAccess] = Array()
        var rideAccessArray: [RideAccess] = Array()
        var discountAccessArray: [DiscountAccess] = Array()
        switch self.type {
        case .foodServices:
            
            areaAccessArray.append(contentsOf: [.amusementAreas,.kitchenAreas])
                            rideAccessArray.append(contentsOf: [.allRides])
            discountAccessArray.append(contentsOf: [.onFood(percentage: 15), .onMarchandise(percentage: 25)])
        case .rideServices: areaAccessArray.append(contentsOf: [.amusementAreas,.rideControlAreas])
        rideAccessArray.append(contentsOf: [.allRides])
        discountAccessArray.append(contentsOf: [.onFood(percentage: 15), .onMarchandise(percentage: 25)])

        case .maintenance:  areaAccessArray.append(contentsOf: [.amusementAreas, .kitchenAreas, .rideControlAreas, .maintenanceAreas])
        rideAccessArray.append(contentsOf: [.allRides])
        discountAccessArray.append(contentsOf: [.onFood(percentage: 15), .onMarchandise(percentage: 25)])

        case .manager: areaAccessArray.append(contentsOf: [.amusementAreas, .kitchenAreas, .rideControlAreas, .maintenanceAreas,.officeAreas])
        rideAccessArray.append(contentsOf: [.allRides])
        discountAccessArray.append(contentsOf: [.onFood(percentage: 25), .onMarchandise(percentage: 25)])

            
        }
        
        access = Access(areaAccess: areaAccessArray, rideAccess: rideAccessArray, discountAccess: discountAccessArray)
        
        return self.access
    }
    
    func swipe() -> Permission {
        
        switch type {
        case .foodServices:
            if let areaAccessArray = self.access.areaAccess, let  rideAccessArray =                                             self.access.rideAccess, let discountAccessArray = self.access.discountAccess{
                if areaAccessArray[0] == AreaAccess.amusementAreas &&
                    areaAccessArray[1] == AreaAccess.kitchenAreas && rideAccessArray[0] == RideAccess.allRides && discountAccessArray[0] == DiscountAccess.onFood(percentage: 15) && discountAccessArray[1] == DiscountAccess.onMarchandise(percentage: 25){
                    return .granted(description: "Granted")
                }
                
            }
        case .rideServices:
            if let areaAccessArray = self.access.areaAccess, let  rideAccessArray = self.access.rideAccess, let discountAccessArray = self.access.discountAccess{
            if areaAccessArray[0] == AreaAccess.amusementAreas &&
                                areaAccessArray[1] == AreaAccess.rideControlAreas && rideAccessArray[0] == RideAccess.allRides && discountAccessArray[0] == DiscountAccess.onFood(percentage: 15) && discountAccessArray[1] == DiscountAccess.onMarchandise(percentage: 25){
                                    return .granted(description: "Granted")
                }
                
            }
        case .maintenance:
            if let areaAccessArray = self.access.areaAccess, let  rideAccessArray =                                             self.access.rideAccess, let discountAccessArray = self.access.discountAccess{
            if areaAccessArray[0] == AreaAccess.amusementAreas &&
                areaAccessArray[1] == AreaAccess.kitchenAreas &&
                areaAccessArray[2] == AreaAccess.rideControlAreas &&
                areaAccessArray[3] == AreaAccess.maintenanceAreas && rideAccessArray[0] == RideAccess.allRides && discountAccessArray[0] == DiscountAccess.onFood(percentage: 15) && discountAccessArray[1] == DiscountAccess.onMarchandise(percentage: 25){
                return .granted(description: "Granted")
            }
           
            }
        case .manager:
                        if let areaAccessArray = self.access.areaAccess, let  rideAccessArray = self.access.rideAccess, let discountAccessArray = self.access.discountAccess{
                                if areaAccessArray[0] == AreaAccess.amusementAreas &&
                                    areaAccessArray[1] == AreaAccess.kitchenAreas &&
                                    areaAccessArray[2] == AreaAccess.rideControlAreas &&
                                    areaAccessArray[3] == AreaAccess.maintenanceAreas &&
                                    areaAccessArray[4] == AreaAccess.officeAreas && rideAccessArray[0] == RideAccess.allRides && (discountAccessArray[0] == DiscountAccess.onFood(percentage: 25)) && (discountAccessArray[1] == DiscountAccess.onMarchandise(percentage: 25)){
                                    return .granted(description: "Granted")
                                }
                            
            }
       
    }
     return .denied(description: "Denied")
}
}

class Guest: Accessable, Swipeable {
    
    var access: Access
    
    let firstName: String?
    let lastName: String?
    let streetAddress: String?
    let city: String?
    let state: String?
    let zipCode: String?
    let socialSecurityNumber: String?
    let dateOfBirth: Date?
    let type: GuestType
    
    init(firstName: String, lastName: String, streetAddress:String, city:String, state: String, zipCode:String, socialSecurityNumber:String, dateOfBirth: Date?, type: GuestType) throws {
        
        if type == GuestType.freeChild {
            guard let dateOfBirth = dateOfBirth else {
                throw EntrantDataError.missingBirthday(description: "Date of birthday required")
            }
            
           let date = Date()
            let calendar = Calendar.current
             let yearnow = calendar.component(.year, from: date)
            let year = calendar.component(.year, from: dateOfBirth)
            let kidAge = yearnow - year
            
            if kidAge > 5 {
                throw EntrantDataError.overFiveYearsOldError(description: "Free child must be under 5 years old")
            }
            
        }
        
        self.firstName = firstName
        self.lastName = lastName
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.socialSecurityNumber = socialSecurityNumber
        self.dateOfBirth = dateOfBirth
        self.type = type
        access = Access(areaAccess: [],rideAccess: [],discountAccess: [])
    }
    
    func generateAccessByEntrantType() -> Access {
        var areaAccessArray: [AreaAccess] = Array()
        var rideAccessArray: [RideAccess] = Array()
        var discountAccessArray: [DiscountAccess] = Array()
        switch self.type {
        case .classic:
            areaAccessArray.append(contentsOf: [.amusementAreas])
            rideAccessArray.append(contentsOf: [.allRides])
        case .vip: areaAccessArray.append(contentsOf: [.amusementAreas])
        rideAccessArray.append(contentsOf: [.allRides,.skipAllRideLines])
        discountAccessArray.append(contentsOf: [.onFood(percentage: 10), .onMarchandise(percentage: 20)])
            
        case .freeChild:  areaAccessArray.append(contentsOf: [.amusementAreas])
        rideAccessArray.append(contentsOf: [.allRides])
          
        }
        
        access = Access(areaAccess: areaAccessArray, rideAccess: rideAccessArray, discountAccess: discountAccessArray)
        
        return self.access
    }
    
    func swipe() -> Permission {
        
        switch type {
        case .classic:
            if let areaAccessArray = self.access.areaAccess, let  rideAccessArray =                                             self.access.rideAccess {
                if areaAccessArray[0] == AreaAccess.amusementAreas && rideAccessArray[0] == RideAccess.allRides {
                    return .granted(description: "Granted")
                }
               
            }
        case .vip:
            if let areaAccessArray = self.access.areaAccess, let  rideAccessArray =                                             self.access.rideAccess, let discountAccessArray = self.access.discountAccess{
                if areaAccessArray[0] == AreaAccess.amusementAreas && rideAccessArray[0] == RideAccess.allRides && rideAccessArray[1] == RideAccess.skipAllRideLines && discountAccessArray[0] == DiscountAccess.onFood(percentage: 10) && discountAccessArray[1] == DiscountAccess.onMarchandise(percentage: 20){
                    return .granted(description: "Granted")
                }
              
            }
        case .freeChild:
            if let areaAccessArray = self.access.areaAccess, let  rideAccessArray =                                             self.access.rideAccess {
                if areaAccessArray[0] == AreaAccess.amusementAreas && rideAccessArray[0] == RideAccess.allRides {
                    return .granted(description: "Granted")
                }
            
            }
    }
         return .denied(description: "Denied")
}
}

// Protocols

protocol Accessable {
    var access: Access {get set}
    
    func generateAccessByEntrantType() -> Access
}

protocol Swipeable {
    func swipe() -> Permission // meter esto en un protocolo para que tanto guest cpmo employees lo imlementen
    
}






