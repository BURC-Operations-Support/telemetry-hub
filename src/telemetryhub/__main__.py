
"""
Telemetry Hub application entrypoint.
Currently an unimplemented stub used to verify CI/CD lifecycle. 
"""

import logging
import signal
import threading

logger = logging.getLogger(__name__)

shutdown = threading.Event()


def main() -> None:
    logging.basicConfig(level=logging.INFO)

    signal.signal(signal.SIGTERM, handle_shutdown)
    signal.signal(signal.SIGINT, handle_shutdown)

    logger.info("Telemetry Hub starting")

    # Placeholder for actual application initialization.
    shutdown.wait()

    logger.info("Telemetry Hub shutting down")


def handle_shutdown(signum: int, frame: object) -> None:
    logger.info("Received shutdown signal: %s", signum)
    shutdown.set()


if __name__ == "__main__":
    main()
