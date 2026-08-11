from pathlib import Path
import pandas as pd
from src.retail_dashboard import etl


def test_load_save(tmp_path: Path):
    df = pd.DataFrame({"a": [1, 2, 3]})
    infile = tmp_path / "in.csv"
    outfile = tmp_path / "out" / "out.csv"
    df.to_csv(infile, index=False)

    loaded = etl.load_csv(infile)
    assert "a" in loaded.columns

    etl.save_processed(loaded, outfile)
    assert outfile.exists()
