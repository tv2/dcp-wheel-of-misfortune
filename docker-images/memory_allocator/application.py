#!/usr/bin/env python3
"""
Resource Test Application

This script allocates memory continuously for testing purposes.
Useful for testing monitoring tools, container limits, and OOM behavior.
"""

import argparse
import time
import sys
import signal
from http.server import HTTPServer, BaseHTTPRequestHandler
from threading import Thread


class HealthHandler(BaseHTTPRequestHandler):
    """Simple HTTP handler for health check endpoint."""
    
    def do_GET(self):
        """Handle GET requests."""
        if self.path == '/health' or self.path == '/healthz':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'OK')
        else:
            self.send_response(404)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'Not Found')
    
    def log_message(self, format, *args):
        """Suppress default request logging."""
        pass


def start_health_server(port):
    """Start HTTP health check server in background thread."""
    server = HTTPServer(('0.0.0.0', port), HealthHandler)
    thread = Thread(target=server.serve_forever, daemon=True)
    thread.start()
    print(f"Health endpoint started on port {port} (GET /health or /healthz)")
    return server



def format_bytes(bytes_size):
    """Format bytes into human-readable format."""
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if bytes_size < 1024.0:
            return f"{bytes_size:.2f} {unit}"
        bytes_size /= 1024.0
    return f"{bytes_size:.2f} PB"


def print_final_stats(total_allocated, num_chunks, iteration, reason="Stopped"):
    """Print final statistics."""
    print(f"\n\n{reason}")
    print(f"Final stats:")
    print(f"  Total allocated: {format_bytes(total_allocated)}")
    print(f"  Total chunks: {num_chunks}")
    print(f"  Iterations: {iteration}")


def main():
    parser = argparse.ArgumentParser(
        description='Resource Test Application - Allocates memory continuously',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s --size 10MB --interval 1
  %(prog)s --size 1GB --interval 0.5
  %(prog)s --size 100KB --interval 0.1
        """
    )
    
    parser.add_argument(
        '--size',
        type=str,
        required=True,
        help='Size of each memory chunk (e.g., 10MB, 1GB, 500KB)'
    )
    
    parser.add_argument(
        '--interval',
        type=float,
        required=True,
        help='Interval in seconds between allocations (can be fractional, e.g., 0.5)'
    )
    
    parser.add_argument(
        '--health-port',
        type=int,
        default=8080,
        help='Port for health check endpoint (default: 8080)'
    )
    
    args = parser.parse_args()
    
    # Parse size parameter
    size_str = args.size.upper()
    multipliers = {
        'B': 1,
        'KB': 1024,
        'MB': 1024 ** 2,
        'GB': 1024 ** 3,
        'TB': 1024 ** 4
    }
    
    chunk_size = None
    for suffix, multiplier in multipliers.items():
        if size_str.endswith(suffix):
            try:
                value = float(size_str[:-len(suffix)])
                chunk_size = int(value * multiplier)
                break
            except ValueError:
                pass
    
    if chunk_size is None:
        print(f"Error: Invalid size format '{args.size}'. Use format like: 10MB, 1GB, 500KB", file=sys.stderr)
        sys.exit(1)
    
    if chunk_size <= 0:
        print("Error: Size must be positive", file=sys.stderr)
        sys.exit(1)
    
    if args.interval <= 0:
        print("Error: Interval must be positive", file=sys.stderr)
        sys.exit(1)
    
    # Start health check server
    health_server = start_health_server(args.health_port)
    
    # List to store allocated memory (prevents garbage collection)
    memory_hog = []
    total_allocated = 0
    iteration = 0
    
    print(f"Resource Test Application Started")
    
    try:
        while True:
            # Allocate memory (create a bytearray filled with data)
            chunk = bytearray(chunk_size)
            memory_hog.append(chunk)
            
            total_allocated += chunk_size
            iteration += 1
            
            time.sleep(args.interval)
        
    except KeyboardInterrupt:
        print_final_stats(total_allocated, len(memory_hog), iteration, "Stopped by user (Ctrl+C)")
    except MemoryError:
        sys.exit(1)


if __name__ == '__main__':
    main()
