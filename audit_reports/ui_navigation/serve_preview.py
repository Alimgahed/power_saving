"""Local profile assets + measurements only; external app connections forbidden."""
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[2]
OUT=Path(__file__).resolve().parent
class Handler(SimpleHTTPRequestHandler):
    def __init__(self,*args,**kwargs):
        super().__init__(*args,directory=str(ROOT/'build/ui_preview'),**kwargs)
    def end_headers(self):
        self.send_header('Content-Security-Policy', "connect-src 'self'; frame-src 'none'; font-src 'self' data:; img-src 'self' data: blob:;")
        super().end_headers()
    def do_GET(self):
        if self.path=='/__fixture_font':
            content=Path('/System/Library/Fonts/Supplemental/Arial Unicode.ttf').read_bytes()
            self.send_response(200);self.send_header('Content-Type','font/ttf');self.send_header('Content-Length',str(len(content)));self.end_headers();self.wfile.write(content);return
        super().do_GET()
    def do_POST(self):
        if self.path!='/__baseline_metrics':
            self.send_error(403);return
        value=json.loads(self.rfile.read(int(self.headers['Content-Length'])))
        with (OUT/'raw_measurements.jsonl').open('a') as f:f.write(json.dumps(value,ensure_ascii=False)+'\n')
        self.send_response(200);self.end_headers();self.wfile.write(b'ok')
ThreadingHTTPServer(('127.0.0.1',8767),Handler).serve_forever()
