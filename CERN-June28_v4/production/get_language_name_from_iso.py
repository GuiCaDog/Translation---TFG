import pandas as pd
import sys


def get_name(iso_code, iso_csv_file):
    with open(iso_csv_file) as csv_in:
        df = pd.read_csv(csv_in)
        try:
            name = df[df['ISO 639-1 Code'] == iso_code]['English name of Language'].values[0]
            print(name)
        except:
            print('Unknown')

if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise Exception("Usage: python3 get_language_name_from_iso.py <iso_639-1_code> <iso_csv>")
    else:
        get_name(sys.argv[1], sys.argv[2])
