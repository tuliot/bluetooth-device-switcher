from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess

KEYBOARD_MAC = ""
TRACKPAD_MAC = ""

class RequestHandler(BaseHTTPRequestHandler):
  def do_GET(self):
      if self.path == "/unpair":
          self.wfile.write(b"Unpairing keyboard and trackpad...\n")
          subprocess.run(["blueutil", "--unpair", KEYBOARD_MAC])
          subprocess.run(["blueutil", "--unpair", TRACKPAD_MAC])
          self.send_response(200, "Unpairing devices")
          self.send_header("Content-type", "text/plain")
          self.end_headers()
      else:
          self.send_response(404, "Not Found")
          self.end_headers()

def run(server_class=HTTPServer, handler_class=RequestHandler, port=36487):
    server_address = ("0.0.0.0", port)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()

if __name__ == "__main__":
    run()