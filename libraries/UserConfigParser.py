import configparser
from pathlib import Path


class UserConfigParser:
    def __init__(self, ini_path: str = "configs/users_config.ini"):
        root = Path(__file__).resolve().parents[1]
        path = root / ini_path
        if not path.exists():
            raise FileNotFoundError(f"User config file not found: {path}")
        self._config = configparser.ConfigParser()
        self._config.read(path, encoding="utf-8")

    def get_user(self, profile: str) -> tuple[str, str]:
        """
        profile: section name, e.g. 'standard_user'
        returns: (username, password)
        """
        section = self._config[profile]
        return section["username"], section["password"]

    def list_profiles(self) -> list[str]:
        return list(self._config.sections())