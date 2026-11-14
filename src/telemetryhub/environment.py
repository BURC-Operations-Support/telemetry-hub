import os
from enum import StrEnum

"""
ENVIRONMENT RESOLVER
DO NOT MODIFY!!!!
DEACTIVATED FOR NOW PENDING REVIEW OF SECRETS MANAGEMENT ARCHITECTURE
"""

# class Environment(StrEnum):
#     DEVELOPMENT = "development"
#     PRODUCTION = "production"

# class BuildProfile(StrEnum):
#     DEVELOPMENT = "development"
#     PRODUCTION = "production"

# class MissingEnvironmentError(Exception):
#     """Exception raised when TELEMETRY_ENV environment variable is not set."""
#     pass

# class EnvironmentMismatchError(Exception):
#     """Exception raised when TELEMETRY_ENV does not match container build profile."""

# def resolve_environment() -> Environment:
#     """
#     Resolves environment from TELEMETRY_ENV environment variable.
#     """
#     raw_env = os.environ.get("TELEMETRY_ENV")

#     if raw_env is None:
#         raise MissingEnvironmentError("TELEMETRY_ENV environment variable must be set to \"development\" or \"production\"." )

#     try:
#         return Environment(raw_env)
#     except ValueError as exc:
#         raise EnvironmentMismatchError(
#             f"Invalid TELEMETRY_ENV: {raw_env!r}"
#         ) from exc

# def resolve_build_profile() -> BuildProfile:
#     """
#     Resolves build profile
#     """
#     return BuildProfile("")

# def validate_environment(
#     environment: Environment,
#     build_profile: BuildProfile,
# ) -> None:
#     if environment != build_profile:
#         raise EnvironmentMismatchError(f"Build profile {build_profile.value} mismatched with environment {environment.value}.")