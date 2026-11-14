import os
from dataclasses import dataclass


@dataclass(frozen=True)
class AppSecrets:
    example_field: str

#TODO: Implement secrets loader
def load_secrets() -> AppSecrets:
    raise NotImplementedError

#TODO: Write validator for secrets dataclass
def validate_secrets(secrets: AppSecrets) -> None:
    raise NotImplementedError