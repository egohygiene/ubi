"""
Utility functions for data processing.
"""

import os
from datetime import datetime
from pathlib import Path
from typing import Any, Dict


def get_xdg_data_dir() -> Path:
    """Get the XDG data directory for storing results."""
    xdg_data_home = os.getenv("XDG_DATA_HOME", Path.home() / ".local" / "share")
    data_dir = Path(xdg_data_home) / "polyglot-example"
    data_dir.mkdir(parents=True, exist_ok=True)
    return data_dir


def save_result(data: Dict[str, Any], filename: str = "result.txt") -> Path:
    """Save processing result to XDG data directory."""
    data_dir = get_xdg_data_dir()
    result_file = data_dir / filename

    with open(result_file, "w") as f:
        f.write(f"Processing Result\n")
        f.write(f"=================\n\n")
        f.write(f"Timestamp: {data.get('timestamp', 'N/A')}\n")
        f.write(f"Status: {data.get('status', 'N/A')}\n")
        f.write(f"Message: {data.get('message', 'N/A')}\n\n")

        if "data" in data:
            f.write(f"Processed Data:\n")
            f.write(f"{data['data']}\n")

    return result_file


def load_latest_result() -> Dict[str, Any]:
    """Load the most recent processing result."""
    data_dir = get_xdg_data_dir()
    result_file = data_dir / "result.txt"

    if not result_file.exists():
        return {"error": "No results found"}

    try:
        with open(result_file, "r") as f:
            content = f.read()
        return {"content": content, "file": str(result_file)}
    except Exception as e:
        return {"error": str(e)}


def format_timestamp() -> str:
    """Format current timestamp."""
    return datetime.now().isoformat()
