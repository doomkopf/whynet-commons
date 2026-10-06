// Thanks to Andy Finnell for the idea to use an AsyncStream: https://losingfight.com/blog/2024/04/14/modeling-condition-variables-in-swift-asyncawait/

/// A monitor object with a `signal` and `waitForSignal` method that is usually used for testing components dealing with concurrency.
public struct WaitContext: Sendable {
    private let waitClosure: @Sendable () async -> Void
    private let streamContinuation: AsyncStream<Void>.Continuation

    public init() {
        let (stream, continuation) = AsyncStream<Void>.makeStream()
        waitClosure = {
            for await _ in stream {}
        }
        streamContinuation = continuation
    }

    public func waitForSignal() async {
        await waitClosure()
    }

    public func signal() {
        streamContinuation.finish()
    }
}
