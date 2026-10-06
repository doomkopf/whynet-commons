import Foundation

public func scheduleOnce(millis: Int64, taskFunc: @escaping ScheduledTaskFunc) {
    DispatchQueue.main.asyncAfter(
        deadline: .now() + TimeInterval(floatLiteral: Double(millis) / 1000)
    ) {
        Task {
            await taskFunc()
        }
    }
}

public func scheduleInterval(millis: Int64) -> ScheduledTask {
    let task = ScheduledTaskImpl()

    internalScheduleInterval(millis: millis, task: task)

    return task
}

private func internalScheduleInterval(millis: Int64, task: ScheduledTaskImpl) {
    Task {
        if await task.cancelled {
            return
        }

        scheduleOnce(millis: millis) {
            if let taskFunc = await task.taskFunc {
                await taskFunc()
            }
            internalScheduleInterval(millis: millis, task: task)
        }
    }
}

public typealias ScheduledTaskFunc = @Sendable () async -> Void

public protocol ScheduledTask: Sendable {
    func setFunc(_ taskFunc: @escaping ScheduledTaskFunc) async
    func setFuncNotAwaiting(_ taskFunc: @escaping ScheduledTaskFunc)
    func cancel() async
}

private actor ScheduledTaskImpl: ScheduledTask {
    fileprivate var taskFunc: ScheduledTaskFunc?
    fileprivate var cancelled = false

    func setFunc(_ taskFunc: @escaping ScheduledTaskFunc) {
        self.taskFunc = taskFunc
    }

    /// Helper method for e.g. classes that schedule internal behavior from the constructor.
    /// For most task scheduling cases it is not relevant to await for the func to be actually set in the task - it will be eventually.
    nonisolated func setFuncNotAwaiting(_ taskFunc: @escaping ScheduledTaskFunc) {
        Task {
            await setFunc(taskFunc)
        }
    }

    func cancel() {
        cancelled = true
    }
}
