#!/usr/bin/env python3
"""
CLI application for generating greetings.

This demonstrates a simple Python CLI tool running in UBI with:
- Click for argument parsing
- XDG-compliant directory usage
- Modern Python packaging
"""

import os
import sys
from pathlib import Path
from typing import Optional

import click


@click.command()
@click.option(
    "--name",
    "-n",
    default="World",
    help="Name to greet",
    show_default=True,
)
@click.option(
    "--greeting",
    "-g",
    default="Hello",
    help="Greeting to use",
    show_default=True,
)
@click.option(
    "--excited",
    "-e",
    is_flag=True,
    help="Add excitement to the greeting",
)
@click.option(
    "--show-env",
    is_flag=True,
    help="Show UBI environment information",
)
def main(
    name: str,
    greeting: str,
    excited: bool,
    show_env: bool,
) -> None:
    """
    A simple greeting CLI tool.

    This tool demonstrates running a Python CLI application in UBI,
    showcasing XDG directory usage and clean command-line interfaces.

    Examples:

        greet --name Alice

        greet --greeting "Good morning" --name Bob

        greet --excited --name "Developer"
    """
    if show_env:
        show_ubi_environment()
        return

    # Build the greeting
    punctuation = "!" if excited else "."
    message = f"{greeting}, {name}{punctuation}"

    # Print with style
    click.echo(click.style(message, fg="green", bold=True))

    # Demonstrate XDG usage
    config_home = os.getenv("XDG_CONFIG_HOME", "~/.config")
    click.echo(
        click.style(
            f"\n📁 Config would be stored in: {config_home}/greet-cli/",
            fg="blue",
            dim=True,
        )
    )


def show_ubi_environment() -> None:
    """Display UBI environment information."""
    click.echo(click.style("\n🌐 UBI Environment Information", fg="cyan", bold=True))
    click.echo(click.style("=" * 50, fg="cyan"))

    # XDG Base Directory variables
    xdg_vars = [
        "XDG_CONFIG_HOME",
        "XDG_CACHE_HOME",
        "XDG_DATA_HOME",
        "XDG_STATE_HOME",
        "XDG_RUNTIME_DIR",
    ]

    click.echo(click.style("\n📁 XDG Base Directories:", fg="yellow"))
    for var in xdg_vars:
        value = os.getenv(var, "Not set")
        click.echo(f"  {var}: {value}")

    # Python-specific variables
    click.echo(click.style("\n🐍 Python Environment:", fg="yellow"))
    python_vars = ["PYTHONUSERBASE", "PYTHONPATH"]
    for var in python_vars:
        value = os.getenv(var, "Not set")
        click.echo(f"  {var}: {value}")

    # General environment
    click.echo(click.style("\n⚙️  General:", fg="yellow"))
    general_vars = ["LANG", "EDITOR", "SHELL", "HOME", "USER"]
    for var in general_vars:
        value = os.getenv(var, "Not set")
        click.echo(f"  {var}: {value}")

    # Python version
    click.echo(click.style("\n🔢 Python Version:", fg="yellow"))
    click.echo(f"  {sys.version}")

    click.echo(click.style("\n" + "=" * 50 + "\n", fg="cyan"))


if __name__ == "__main__":
    main()
