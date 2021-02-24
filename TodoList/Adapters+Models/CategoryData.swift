//
//	CategoryData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class CategoryData : NSObject, NSCoding, Mappable{

	var v : Int?
	var id : String?
    var changeStreamCreatedAt : String?
	var createdAt : String?
	var name : String?
	var updatedAt : String?
    var owner : UserData?
    var synced : Bool = true
    var fetchId : String?


	class func newInstance(map: Map) -> Mappable?{
		return CategoryData()
	}
	required init?(map: Map){}
	public override init(){}

	func mapping(map: Map)
	{
		v <- map["__v"]
		id <- map["_id"]
        changeStreamCreatedAt <- map["changeStreamCreatedAt"]
		createdAt <- map["createdAt"]
		name <- map["name"]
		owner <- map["owner"]
		updatedAt <- map["updatedAt"]
		
	}
    
    func fromGenericModel(generic: EntityData?)-> CategoryData {
        
        let data            = CategoryData()
        let userData        = UserData()
        
        data.id             = generic?.id
    
        data.createdAt      = generic?.createdAt
        data.name           = generic?.name
        
        userData.id         = generic?.owner?.id
        userData.name       = generic?.owner?.name
        userData.email      = generic?.owner?.email
        
        data.owner          = userData
        data.updatedAt      = generic?.updatedAt
        
        return data
        
    }
    
    func fromNSManagedObject(categories: [NSCategory])-> [CategoryData] {
        
        var arrCategories = [CategoryData]()
        
        for category in categories {
            
            let data            = CategoryData()
            let userData        = UserData()
            
            data.id             = category.id
            if let id = category.serverId {
                data.id             = id
            }
            data.createdAt      = category.createdAt
            data.name           = category.name
            
            userData.id         = category.ownerId
            userData.name       = category.ownerName
            userData.email      = category.ownerEmail
            
            data.owner          = userData
            
            data.updatedAt      = category.updatedAt
            data.synced         = category.synced
            
            arrCategories.append(data)
        }
        
        return arrCategories
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         v = aDecoder.decodeObject(forKey: "__v") as? Int
         id = aDecoder.decodeObject(forKey: "_id") as? String
         createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         owner = aDecoder.decodeObject(forKey: "owner") as? UserData
         updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if v != nil{
			aCoder.encode(v, forKey: "__v")
		}
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "createdAt")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if owner != nil{
			aCoder.encode(owner, forKey: "owner")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updatedAt")
		}

	}

}
