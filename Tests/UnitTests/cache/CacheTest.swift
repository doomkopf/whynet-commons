import Testing

@testable import WhynetCommons

struct CacheTest {
    @Test
    func putAndGetEntry() throws {
        let cache = try CacheImpl<String, String>(entryEvictionTimeMillis: 1, maxEntries: 1)

        #expect(cache.getAt(key: "key", now: 1) == nil)

        cache.putAt(key: "key", value: "v", now: 1)

        #expect(cache.get(key: "key") == "v")
    }

    @Test
    func dropOldestEntryWhenFull() throws {
        let cache = try CacheImpl<String, String>(entryEvictionTimeMillis: 1, maxEntries: 2)
        cache.putAt(key: "key2", value: "v2", now: 2)
        cache.putAt(key: "key1", value: "v1", now: 1)
        cache.putAt(key: "key3", value: "v3", now: 3)

        #expect(cache.size == 2)

        #expect(cache.getAt(key: "key1", now: 4) == nil)
        #expect(cache.getAt(key: "key2", now: 4) == "v2")
        #expect(cache.getAt(key: "key3", now: 4) == "v3")
    }

    @Test
    func invalidateOutdatedKeys() throws {
        class TestListener: CacheListener {
            var key1 = 0
            var key3 = 0
            func onEntryEvicted(key: String, value: String) {
                if key == "key1" && value == "v1" {
                    key1 += 1
                }
                if key == "key3" && value == "v3" {
                    key3 += 1
                }
            }
        }
        let listener = TestListener()

        let evictionTime: Int64 = 10
        let cache = try CacheImpl<String, String>(
            entryEvictionTimeMillis: evictionTime, maxEntries: 4)
        cache.setListener(listener)
        cache.putAt(key: "key1", value: "v1", now: 1)
        cache.putAt(key: "key2", value: "v2", now: 3)
        cache.putAt(key: "key3", value: "v3", now: 2)
        cache.putAt(key: "keyPutBeforeButGetLater", value: "v4", now: 1)

        _ = cache.getAt(key: "keyPutBeforeButGetLater", now: 3)

        let future = evictionTime + 3
        cache.cleanupAt(future)

        #expect(cache.size == 2)

        #expect(cache.getAt(key: "key1", now: future) == nil)
        #expect(cache.getAt(key: "key2", now: future) == "v2")
        #expect(cache.getAt(key: "key3", now: future) == nil)
        #expect(cache.getAt(key: "keyPutBeforeButGetLater", now: future) == "v4")

        #expect(listener.key1 == 1)
        #expect(listener.key3 == 1)
    }

    @Test
    func beEmptyAfterClear() throws {
        let cache = try CacheImpl<String, String>(entryEvictionTimeMillis: 1, maxEntries: 2)
        cache.putAt(key: "key1", value: "v1", now: 1)
        cache.putAt(key: "key2", value: "v2", now: 1)

        cache.clear()

        #expect(cache.size == 0)

        #expect(cache.getAt(key: "key1", now: 1) == nil)
        #expect(cache.getAt(key: "key2", now: 1) == nil)
    }
}
