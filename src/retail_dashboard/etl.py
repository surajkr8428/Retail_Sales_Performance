"""ETL helpers for Retail Sales Performance Dashboard."""
from pathlib import Path
import pandas as pd


def load_csv(path: Path) -> pd.DataFrame:
    """Load CSV with basic hygiene.

    Args:
        path: path to csv file

    Returns:
        DataFrame
    """
    df = pd.read_csv(path)
    # basic cleanup placeholder
    return df


def save_processed(df: pd.DataFrame, out: Path) -> None:
    out.parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(out, index=False)
