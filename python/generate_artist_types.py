import pandas as pd
import random

random.seed(42)

# Load artists
artists = pd.read_csv("data/artists.csv")

print("Artists loaded:", len(artists))

# ============================================================
# ASSIGN ARTIST TYPE
# ============================================================

artist_ids = artists["Artist_id"].tolist()

random.shuffle(artist_ids)

# Approximately 80% individual artists and 20% groups
split_point = int(len(artist_ids) * 0.80)

single_ids = artist_ids[:split_point]
group_ids = artist_ids[split_point:]

# ============================================================
# SINGLE
# ============================================================

single = pd.DataFrame({
    "Artist_id": single_ids
})

single["Age"] = [
    random.randint(18, 70)
    for _ in range(len(single))
]

# ============================================================
# ARTIST_GROUP
# ============================================================

artist_group = pd.DataFrame({
    "Artist_id": group_ids
})

artist_group["Total_members"] = [
    random.randint(2, 8)
    for _ in range(len(artist_group))
]

# Sort IDs
single = single.sort_values("Artist_id").reset_index(drop=True)
artist_group = artist_group.sort_values("Artist_id").reset_index(drop=True)

# ============================================================
# SAVE
# ============================================================

single.to_csv(
    "data/single.csv",
    index=False
)

artist_group.to_csv(
    "data/artist_group.csv",
    index=False
)

# ============================================================
# VALIDATION
# ============================================================

print("\n===== ARTIST SPECIALIZATION COMPLETE =====")

print("Total artists:", len(artists))
print("Single artists:", len(single))
print("Artist groups:", len(artist_group))

print(
    "Total classified:",
    len(single) + len(artist_group)
)

print(
    "Unclassified artists:",
    len(artists) -
    len(single) -
    len(artist_group)
)

print("\n===== SAMPLE SINGLE =====")
print(single.head(5).to_string(index=False))

print("\n===== SAMPLE ARTIST GROUP =====")
print(artist_group.head(5).to_string(index=False))