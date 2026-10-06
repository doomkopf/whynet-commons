# Whynet-Commons

A collection of reusable tools used by Whynet and Gammaray

### Cache

A very generic and non-Sendable form of a Cache. The only difference to a Dictionary/Map is that it supports entry eviction and a maximum amount of entries always dropping the oldest one.

### Task scheduling

- scheduleOnce
- scheduleInterval returning a task that can be canceled

### WaitContext

A monitor object with a `signal` and `waitForSignal` method that is usually used for testing components dealing with concurrency.

### StringJSONEncoder and StringJSONDecoder

Basically just like the standard JSONEncoder and JSONDecoder but also taking plain strings into account.
