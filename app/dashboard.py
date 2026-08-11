"""Minimal Streamlit dashboard starter."""
import streamlit as st
from pathlib import Path
import pandas as pd


def load_data(path: Path) -> pd.DataFrame:
    return pd.read_csv(path)


def main():
    st.title("Retail Sales Performance Dashboard")
    st.write("Use the left panel to load data and configure views.")

    data_file = st.file_uploader("Upload processed CSV", type=["csv"])
    if data_file:
        df = pd.read_csv(data_file)
        st.dataframe(df.head())


if __name__ == "__main__":
    main()
