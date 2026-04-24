import json
import mimetypes
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path
from urllib.parse import urlparse

from healthcare_bot import PROJECT_NAME, WELCOME_MESSAGE, chatbot_reply, get_quick_commands

BASE_DIR = Path(__file__).resolve().parent
STATIC_DIR = BASE_DIR / "static"


class MyHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        path = urlparse(self.path).path

        # serve the main page
        if path == "/" or path == "/index.html":
            self.serve_file(STATIC_DIR / "index.html")
            return

        # serve static files like css and js
        if path.startswith("/static/"):
            filename = path.replace("/static/", "")
            self.serve_file(STATIC_DIR / filename)
            return

        # api to get command buttons for the website
        if path == "/api/commands":
            data = {
                "project": PROJECT_NAME,
                "welcome": WELCOME_MESSAGE,
                "commands": get_quick_commands()
            }
            self.send_json(data)
            return

        # 404 if route not found
        self.send_json({"error": "not found"}, code=404)

    def do_POST(self):
        path = urlparse(self.path).path

        if path == "/api/chat":
            # read body
            length = int(self.headers.get("Content-Length", 0))
            body = self.rfile.read(length) if length > 0 else b"{}"

            try:
                payload = json.loads(body.decode("utf-8"))
            except:
                self.send_json({"error": "bad json"}, code=400)
                return

            msg = str(payload.get("message", ""))
            reply = chatbot_reply(msg)
            self.send_json(reply)
            return

        self.send_json({"error": "not found"}, code=404)

    def serve_file(self, filepath):
        if not filepath.exists():
            self.send_json({"error": "file not found"}, code=404)
            return

        content_type, _ = mimetypes.guess_type(str(filepath))
        content_type = content_type or "application/octet-stream"
        data = filepath.read_bytes()

        self.send_response(200)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def send_json(self, data, code=200):
        body = json.dumps(data).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, format, *args):
        # suppress default logs
        pass


def main():
    host = "127.0.0.1"
    port = 8000
    server = HTTPServer((host, port), MyHandler)
    print(f"{PROJECT_NAME} - Web Server")
    print(f"Open http://{host}:{port} in your browser")
    print("Press Ctrl+C to stop.")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped.")


if __name__ == "__main__":
    main()
