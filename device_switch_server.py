from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess
import os

KEYBOARD_MAC = os.getenv("KEYBOARD_MAC")
TRACKPAD_MAC = os.getenv("TRACKPAD_MAC")
BLUEUTIL_PATH = os.getenv("BLUEUTIL_PATH")
PORT = int(os.getenv("PORT"))

class RequestHandler(BaseHTTPRequestHandler):
  def do_GET(self):
      if self.path == "/unpair":
          self.wfile.write(b"Unpairing keyboard and trackpad...\n")
          subprocess.run([BLUEUTIL_PATH, "--unpair", KEYBOARD_MAC])
          subprocess.run([BLUEUTIL_PATH, "--unpair", TRACKPAD_MAC])
          self.send_response(200, "Unpairing devices")
          self.send_header("Content-type", "text/plain")
          self.end_headers()
      else:
          self.send_response(404, "Not Found")
          self.end_headers()

def run(server_class=HTTPServer, handler_class=RequestHandler, port=PORT):
    server_address = ("0.0.0.0", port)
    print(f"Starting server on {server_address}")
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()

if __name__ == "__main__":
    run()
