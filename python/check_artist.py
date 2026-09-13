import pandas as pd

df = pd.read_csv("data/artists.csv")

print("=" * 60)
print("ARTIST DATA TYPE CHECK")
print("=" * 60)

print("\nDATA TYPES:")
print(df.dtypes)

print("\nFIRST 10 ARTIST IDs:")
print(df["Artist_id"].head(10).to_list())

print("\nARTIST ID TYPE:")
print(type(df["Artist_id"].iloc[0]))

# Find values that cannot be converted to numbers
numeric_ids = pd.to_numeric(df["Artist_id"], errors="coerce")

bad_ids = df[numeric_ids.isna()]

print("\nINVALID ARTIST IDs:")
print(bad_ids[["Artist_id", "Name"]].head(20))

print("\nNUMBER OF INVALID ARTIST IDs:")
print(len(bad_ids))

print("\nUNIQUE ARTIST ID COUNT:")
print(df["Artist_id"].nunique())

print("\nTOTAL ARTISTS:")
print(len(df))