@testable import Backend
import CoreData
import XCTest

final class BackendTests: XCTestCase {
    var networkProvider: NetworkProviderProtocol!
    var storeProvider: StoreProviderProtocol!

    override func setUp() {
        super.setUp()
        networkProvider = NetworkProvider()
        storeProvider = StoreProvider(networkProvider: networkProvider, inMemory: true)
    }

    func testListSuperheroes() throws {
        let superheroes = try awaitPublisher(storeProvider.listSuperheroes(), timeout: 60)
        let request: NSFetchRequest<Superhero> = Superhero.fetchRequest()
        let persistentSuperheroes: [Superhero]
        do {
            persistentSuperheroes = try storeProvider.persistentContainer.viewContext.fetch(request)
        } catch {
            persistentSuperheroes = []
            print("Fetch failed")
        }
        XCTAssertGreaterThan(superheroes.count, 0)
        XCTAssertEqual(superheroes.count, persistentSuperheroes.count)
    }
}
