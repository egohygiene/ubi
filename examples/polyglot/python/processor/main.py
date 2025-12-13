#!/usr/bin/env python3
"""
Main data processor.

This module provides the core data processing functionality.
"""

import os
import sys
from typing import Any, Dict

import click

from .utils import format_timestamp, get_xdg_data_dir, load_latest_result, save_result


def process_data(input_data: str) -> Dict[str, Any]:
    """
    Process input data and return results.

    This is a simple demonstration that:
    1. Accepts input data
    2. Performs some "processing" (transformation)
    3. Saves results to XDG data directory
    4. Returns status information
    """
    timestamp = format_timestamp()

    # Simple processing: transform to uppercase and add metadata
    processed = {
        "original": input_data,
        "processed": input_data.upper(),
        "length": len(input_data),
        "word_count": len(input_data.split()),
    }

    # Prepare result
    result = {
        "timestamp": timestamp,
        "status": "success",
        "message": "Data processed successfully",
        "data": processed,
    }

    # Save to XDG data directory
    result_file = save_result(result)

    click.echo(click.style("✅ Processing complete!", fg="green", bold=True))
    click.echo(f"📁 Results saved to: {result_file}")

    return result


@click.command()
@click.option(
    "--input",
    "-i",
    default="Sample data for processing",
    help="Input data to process",
    show_default=True,
)
@click.option(
    "--show-result",
    "-s",
    is_flag=True,
    help="Display the latest processing result",
)
@click.option(
    "--show-env",
    is_flag=True,
    help="Show environment information",
)
def main(input: str, show_result: bool, show_env: bool) -> None:
    """
    Data processor for the polyglot example.

    This Python component handles data processing tasks and coordinates
    with the Node.js API server through shared XDG directories.

    Examples:

        python -m processor.main --input "Hello World"

        python -m processor.main --show-result

        python -m processor.main --show-env
    """
    if show_env:
        show_environment()
        return

    if show_result:
        result = load_latest_result()
        if "error" in result:
            click.echo(click.style(f"❌ {result['error']}", fg="red"))
        else:
            click.echo(click.style("📄 Latest Result:", fg="cyan", bold=True))
            click.echo(result["content"])
        return

    # Process the input data
    click.echo(click.style("\n🔄 Processing data...", fg="blue"))
    click.echo(f"Input: {input}\n")

    result = process_data(input)

    # Display summary
    click.echo(click.style("\n📊 Summary:", fg="yellow"))
    click.echo(f"  Status: {result['status']}")
    click.echo(f"  Timestamp: {result['timestamp']}")
    click.echo(f"  Original length: {result['data']['length']}")
    click.echo(f"  Word count: {result['data']['word_count']}")


def show_environment() -> None:
    """Display environment information."""
    click.echo(click.style("\n🐍 Python Processor Environment", fg="cyan", bold=True))
    click.echo(click.style("=" * 50, fg="cyan"))

    # XDG directories
    click.echo(click.style("\n📁 XDG Data Directory:", fg="yellow"))
    data_dir = get_xdg_data_dir()
    click.echo(f"  {data_dir}")

    # Environment variables
    click.echo(click.style("\n⚙️  Environment Variables:", fg="yellow"))
    important_vars = [
        "XDG_CONFIG_HOME",
        "XDG_CACHE_HOME",
        "XDG_DATA_HOME",
        "XDG_STATE_HOME",
        "PYTHONUSERBASE",
        "HOME",
        "USER",
    ]
    for var in important_vars:
        value = os.getenv(var, "Not set")
        click.echo(f"  {var}: {value}")

    # Python info
    click.echo(click.style("\n🔢 Python Information:", fg="yellow"))
    click.echo(f"  Version: {sys.version}")
    click.echo(f"  Executable: {sys.executable}")

    click.echo(click.style("\n" + "=" * 50 + "\n", fg="cyan"))


if __name__ == "__main__":
    main()
