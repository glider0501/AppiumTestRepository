import configparser
import json
import os
from pathlib import Path

from dotenv import load_dotenv
from robot.api import logger

ROOT = Path(__file__).resolve().parents[1]
load_dotenv(ROOT / "file.env")


class Config:
    """
    Reads configs/config.ini and merges with environment variables.

    Usage from Robot:
        Library    libraries/Config.py
        ${remote}=    Get Appium Server Url
        &{caps}=      Get Merged Caps
        Open Application    ${remote}    &{caps}
    """

    def __init__(self, ini_path: str = "configs/config.ini"):
        self._root = ROOT
        self._config_path = self._root / ini_path
        if not self._config_path.exists():
            raise FileNotFoundError(f"Config file not found: {self._config_path}")
        self._config = configparser.ConfigParser()
        self._config.read(self._config_path, encoding="utf-8")

    @staticmethod
    def _get_env(name: str, default=None):
        val = os.getenv(name)
        return val if val is not None and val != "" else default


    def get_appium_remote_host(self) -> str:
        # env overrides config.ini; config has no [appium], so just use env
        return self._get_env("APPIUM_HOST", "127.0.0.1")

    def get_appium_remote_port(self) -> str:
        return str(self._get_env("APPIUM_PORT", "4723"))

    def get_appium_remote_path(self) -> str:
        path = self._get_env("APPIUM_BASE_PATH", "") or ""
        path = path.strip()
        if path and not path.startswith("/"):
            path = "/" + path
        return path

    def get_appium_server_url(self) -> str:
        host = self.get_appium_remote_host()
        port = self.get_appium_remote_port()
        path = self.get_appium_remote_path()
        return f"http://{host}:{port}{path}"


    def get_device_profile(self) -> str:
        # required in config.ini
        return self._config["device"].get("profile")

    def get_app_caps_name(self) -> str:
        # required in config.ini
        return self._config["app"].get("app_capabilities")


    def get_device_caps(self) -> dict:
        """
        Load base device caps from JSON, then override with env variables.
        Ensures deviceName is present.
        """
        profile = self.get_device_profile()
        caps_path = self._root / "configs" / "devices" / f"{profile}.json"
        with open(caps_path, "r", encoding="utf-8") as f:
            caps = json.load(f)

        platform_name = self._get_env("PLATFORM_NAME", caps.get("platformName", "").strip())
        if platform_name:
            caps["platformName"] = platform_name

        platform_version = self._get_env("PLATFORM_VERSION", caps.get("platformVersion", "").strip())
        if platform_version:
            caps["platformVersion"] = str(platform_version)

        device_name = self._get_env("DEVICE_NAME", caps.get("deviceName", "").strip())
        if device_name:
            caps["deviceName"] = device_name

        udid = self._get_env("UDID", caps.get("udid", "").strip())
        if udid:
            caps["udid"] = udid

        if "deviceName" not in caps or not str(caps["deviceName"]).strip():
            raise RuntimeError("deviceName is required but not set (JSON/env).")

        return caps

    def get_app_caps(self) -> dict:
        """
        Load app-specific caps from JSON and set 'app' from env or config if present.
        """
        app_caps_name = self.get_app_caps_name()
        caps_path = self._root / "configs" / "app" / "cap" / f"{app_caps_name}.json"
        with open(caps_path, "r", encoding="utf-8") as f:
            caps = json.load(f)

        app_path_env = self._get_env("APP_PATH")
        if app_path_env:
            app_path = Path(app_path_env)
            if not app_path.is_absolute():
                app_path = self._root / app_path_env
            caps["app"] = str(app_path)
        else:
            logger.error("APP_PATH is not set in environment variables.")

        return caps

    def get_merged_caps(self) -> dict:
        """
        Merge device caps and app caps into one dict for Open Application.
        """
        caps = self.get_device_caps()
        app_caps = self.get_app_caps()
        caps.update(app_caps)
        return caps
