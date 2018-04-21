import App
import PerfectLib

do {
    try App.start()
} catch PerfectError.networkError(let code, let message) {
    print("NETWORK error \(code), \(message)")
} catch {
    print("Failed to start: \(error)")
}

