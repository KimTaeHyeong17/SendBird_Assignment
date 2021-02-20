//
//  BookModelEntity+CoreDataProperties.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/21.
//
//

import Foundation
import CoreData


extension BookModelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookModelEntity> {
        return NSFetchRequest<BookModelEntity>(entityName: "BookModelEntity")
    }

    @NSManaged public var image: String?
    @NSManaged public var isbn13: String?
    @NSManaged public var price: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var origin: SearchResultEntity?

}

extension BookModelEntity : Identifiable {

}
