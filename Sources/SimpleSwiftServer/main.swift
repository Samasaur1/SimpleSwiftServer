import Swifter
import Dispatch
import Foundation.NSFileManager
import SwiftIP

let server = HttpServer()
server["/files/:path"] = directoryBrowser(FileManager().currentDirectoryPath)
server["/"] = { request in
    return .movedPermanently("files/")
}

let semaphore = DispatchSemaphore(value: 0)
do {
    if CommandLine.arguments.count > 1, let port = UInt16(CommandLine.arguments[1]) {
        try server.start(port, forceIPv4: true)
    } else {
        try server.start(1234, forceIPv4: true)
    }
    print("Server has started on port \(try server.port()). Try to connect now...")
    print()
    print("Others can do so by going to \"\(try IP.local()):\(try server.port())\" in a browser")
    semaphore.wait()
} catch {
    print("Server start error: \(error)")
    semaphore.signal()
}
