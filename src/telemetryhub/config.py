from dataclasses import dataclass


#TODO: Define app config fields
@dataclass(frozen=True)
class AppConfig:
    example_field: str

def load_config() -> AppConfig:
    raise NotImplementedError

def validate_config(config: AppConfig) -> None:
    raise NotImplementedError