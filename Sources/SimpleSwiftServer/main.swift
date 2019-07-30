import Swifter
import Dispatch
import Foundation.NSFileManager
import SwiftIP

enum Mode {
    case directoryBrowser
    case fileDownload
}
extension String {
    public var fileName: String {
        return URL(fileURLWithPath: self).lastPathComponent
    }
}

let args = Array(CommandLine.arguments.dropFirst())
var port: UInt16 = 1234
var mode: Mode = .directoryBrowser
var path: String = "." //These should be constants, but the Swift compiler is being stupid
if args.isEmpty {
    port = 1234
    mode = .directoryBrowser
    path = "."
} else {
    if args.count == 1 {
        port = UInt16(args[0]) ?? 1234
        mode = .directoryBrowser
        path = "."
    } else if args.count == 2 {
        if let p = UInt16(args[0]) {
            port = p
            mode = .directoryBrowser
            path = "."
        } else {
            port = 1234
            if args[0] == "--file" {
                mode = .fileDownload
                path = args[1]
            } else if args[0] == "--browse" {
                mode = .directoryBrowser
                path = args[1]
            }
        }
    } else {
        port = UInt16(args[0]) ?? 1234
        if args[1] == "--file" {
            mode = .fileDownload
            path = args[2]
        } else if args[1] == "--browse" {
            mode = .directoryBrowser
            path = args[2]
        }
    }
}

let server = HttpServer()

switch mode {
case .directoryBrowser:
    server["/files/:path"] = directoryBrowser(path)
    server["/"] = { _ in
        return .ok(.html(#"<html><head><script>window.location = "files/"</script></head></html>"#))
    }
case .fileDownload:
    server["/file/"] = { _ in
        if let file = try? path.openForReading() {
            return .raw(200, "OK", ["Content-Type": "application/octet-stream", "Content-Disposition": "attachment; filename=\(path.fileName)"], { writer in
                try? writer.write(file)
                file.close()
            })
        }
        return .notFound
    }
    server["/"] = { _ in
        return .ok(.html(#"<html><head><script>window.location = "file/"</script></head></html>"#))
    }
}



let semaphore = DispatchSemaphore(value: 0)
do {
    try server.start(port, forceIPv4: true)
    print("Server has started on port \(try server.port()). Try to connect now...")
    print()
    print("Others can do so by going to \"\(try IP.local()):\(try server.port())\" in a browser")
    semaphore.wait()
} catch {
    print("Server start error: \(error)")
    semaphore.signal()
}
