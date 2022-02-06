import Swifter
import Dispatch
import Foundation
import SwiftIP
import ArgumentParser

extension String {
    public var fileName: String {
        return URL(fileURLWithPath: self).lastPathComponent
    }
}
extension HttpResponse {
    static func movedTemporarily(_ location: String) -> HttpResponse {
        return .raw(307, "Moved Temporarily", ["Location": location], nil)
    }
}

struct Server: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "server",
        abstract: "Host a little server.",
        discussion: "This command lets you host multiple different types of servers on your local machine, accessible to anyone on the network.",
        version: "4.3.1",
        shouldDisplay: true,
        subcommands: [],
        defaultSubcommand: nil,
        helpNames: [.short, .long]
    )
    enum Mode: String, EnumerableFlag {
        case directoryBrowser = "browse"
        case fileDownload = "file"
        case webServer = "webserver"
        case HTMLFile = "html"

        static func name(for value: Server.Mode) -> NameSpecification {
            return .customLong(value.rawValue)
        }
    }

    @Option(name: .long, help: "The port for the server to run on") var port: UInt16 = 1234
    @Flag(help: "The server mode") var mode: Mode = .directoryBrowser
    @Argument(help: "The path to the file/directory") var path: String = "."
    @Flag(name: .long, help: "Whether or not to log incoming requests") var debug = false

    func run() throws {
        let server = HttpServer()

        switch mode {
        case .directoryBrowser:
            server["/files/:path"] = directoryBrowser(path)
            server["/"] = { _ in
                return .movedTemporarily("files/")
            }
        case .fileDownload:
            server["/file/"] = { _ in
                if let file = try? self.path.openForReading() {
                    return .raw(200, "OK", ["Content-Type": "application/octet-stream", "Content-Disposition": "attachment; filename=\(self.path.fileName)"], { writer in
                        try? writer.write(file)
                        file.close()
                    })
                }
                return .notFound
            }
            server["/"] = { _ in
                return .movedTemporarily("file/")
            }
        case .webServer:
            server["/web/:path"] = { r in
                guard let f = r.params.first else {
                    return .notFound
                }
                r.params[f.key] = f.value.removingPercentEncoding
                return shareFilesFromDirectory(path)(r)
            }
            server["/"] = { _ in
                return .movedTemporarily("web/")
            }
        case .HTMLFile:
            server["/page/"] = shareFile(path)
            server["/"] = { _ in
                return .movedTemporarily("page/")
            }
        }

        if debug {
            server.middleware.append { req in
                print("\(req.method) request from \(req.address ?? "unknown address") to \(req.path)")
                return nil
            }
        }

        let semaphore = DispatchSemaphore(value: 0)
        do {
            try server.start(port, forceIPv4: true)
            print("Server has started on port \(try server.port()). Try to connect now...")
            print()
            print("Others can do so by going to \"\(IP.local() ?? "localhost"):\(try server.port())\" in a browser")
            semaphore.wait()
        } catch {
            print("Server start error: \(error)")
            semaphore.signal()
        }
    }
}

Server.main()
