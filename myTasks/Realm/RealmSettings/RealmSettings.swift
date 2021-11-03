//
//  RealmSettings.swift
//  myTasks
//
//  Created by Максим Хлесткин on 03.11.2021.
//

import RealmSwift

class RealmSetup {
    static func performRealmMigrations() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 0,
            migrationBlock: { migration, oldSchemaVersion in },
            deleteRealmIfMigrationNeeded: true
        )
    }
    
}
