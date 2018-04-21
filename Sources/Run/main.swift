import App
import PerfectLib

let backend = App.Backend()

do {
    try backend.start()
} catch PerfectError.networkError(let code, let message) {
    print("NETWORK error \(code), \(message)")
} catch {
    print("Failed to start")
}

