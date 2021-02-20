//
//  SearchResultEntity+CoreDataProperties.swift
//  SendbirdAssignment_TaeHyeongKim
//
//  Created by TaeHyeong Kim on 2021/02/21.
//
//

import Foundation
import CoreData


extension SearchResultEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchResultEntity> {
        return NSFetchRequest<SearchResultEntity>(entityName: "SearchResultEntity")
    }

    @NSManaged public var page: String?
    @NSManaged public var total: String?
    @NSManaged public var keyword: String?
    @NSManaged public var books: NSOrderedSet?

}

// MARK: Generated accessors for books
extension SearchResultEntity {

    @objc(insertObject:inBooksAtIndex:)
    @NSManaged public func insertIntoBooks(_ value: BookModelEntity, at idx: Int)

    @objc(removeObjectFromBooksAtIndex:)
    @NSManaged public func removeFromBooks(at idx: Int)

    @objc(insertBooks:atIndexes:)
    @NSManaged public func insertIntoBooks(_ values: [BookModelEntity], at indexes: NSIndexSet)

    @objc(removeBooksAtIndexes:)
    @NSManaged public func removeFromBooks(at indexes: NSIndexSet)

    @objc(replaceObjectInBooksAtIndex:withObject:)
    @NSManaged public func replaceBooks(at idx: Int, with value: BookModelEntity)

    @objc(replaceBooksAtIndexes:withBooks:)
    @NSManaged public func replaceBooks(at indexes: NSIndexSet, with values: [BookModelEntity])

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: BookModelEntity)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: BookModelEntity)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSOrderedSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSOrderedSet)

}

extension SearchResultEntity : Identifiable {

}
