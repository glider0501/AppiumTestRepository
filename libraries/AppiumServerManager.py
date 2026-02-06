
import socket
import subprocess
import time

from robot.api import logger

from Config import Config  # your adjusted config helper


class AppiumServerManager:
    """
    Start/stop Appium server programmatically based on config/env.

    Robot usage:
        Library    AppiumServerManager.py
        Suite Setup     Start Appium If Needed
        Suite Teardown  Stop Appium If Started
    """

    def __init__(self, ini_path: str = "configs/config.ini"):
        self._config = Config(ini_path)
        self._process: subprocess.Popen | None = None

    @staticmethod
    def _is_port_open(host: str, port: int, timeout: float = 1.0) -> bool:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            sock.settimeout(timeout)
            try:
                sock.connect((host, port))
                return True
            except OSError:
                return False

    def start_appium_if_needed(self, wait_seconds: float = 20.0):
        """
        Keyword: Start Appium If Needed - WORKING VERSION
        """
        host = self._config.get_appium_remote_host()
        port = int(self._config.get_appium_remote_port())
        base_path = self._config.get_appium_remote_path()

        if self._is_port_open(host, port):
            logger.info(f"[AppiumServerManager] {host}:{port} already open.")
            return

        cmd = [
            "appium", "server",
            "--address", host,
            "--port", str(port),
        ]
        if base_path:
            cmd.extend(["--base-path", base_path])

        logger.info(f"[AppiumServerManager] Starting: {' '.join(cmd)}")

        self._process = subprocess.Popen(
            cmd,
            shell=True,
            creationflags=subprocess.CREATE_NEW_CONSOLE,  # VISIBLE WINDOW
        )

        end_time = time.time() + wait_seconds
        while time.time() < end_time:
            if self._process.poll() is not None:
                logger.error("Appium process died unexpectedly")
                raise RuntimeError("Appium process died unexpectedly")
            if self._is_port_open(host, port):
                logger.info(f"[AppiumServerManager] Appium ready: {host}:{port}")
                return
            time.sleep(0.5)

        self._process.kill()
        logger.error(f"Appium failed to start on {host}:{port}")
        raise RuntimeError(f"Appium failed to start on {host}:{port}")

    def stop_appium_if_started(self):
        """
        Keyword: Stop Appium If Started

        Stops Appium process started by this manager (if any).
        """
        if self._process is None:
            logger.info("[AppiumServerManager] No Appium process was started by this manager.")
            return

        logger.info("[AppiumServerManager] Terminating Appium process...")
        self._process.terminate()
        try:
            self._process.wait(timeout=10)
        except subprocess.TimeoutExpired:
            logger.info("[AppiumServerManager] Appium did not exit gracefully, killing it.")
            self._process.kill()
        finally:
            self._process = None

