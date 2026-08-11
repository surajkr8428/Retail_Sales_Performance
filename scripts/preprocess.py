"""Command-line preprocessing entrypoint."""
from pathlib import Path
import argparse
from src.retail_dashboard import etl


def main():
    parser = argparse.ArgumentParser(description="Preprocess raw retail CSVs")
    parser.add_argument("--input", required=True)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()

    input_path = Path(args.input)
    output_path = Path(args.output)

    for csv in input_path.glob("*.csv"):
        df = etl.load_csv(csv)
        # placeholder for preprocessing
        out = output_path / csv.name
        etl.save_processed(df, out)


if __name__ == "__main__":
    main()
