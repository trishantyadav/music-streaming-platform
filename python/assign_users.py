import pandas as pd
import numpy as np
import random
from datetime import timedelta

random.seed(42)
np.random.seed(42)

# ============================================================
# LOAD DATA
# ============================================================

history = pd.read_csv(
    "data/listening_history.csv",
    parse_dates=["Played_at"]
)

users = pd.read_csv(
    "data/users.csv"
)

print("Listening records:", len(history))
print("Users:", len(users))

# ============================================================
# CREATE REALISTIC USER ACTIVITY WEIGHTS
# ============================================================

num_users = len(users)

# Earlier users are not necessarily more active.
# Create a power-law-like distribution so some users
# have many more listening events than others.

ranks = np.arange(1, num_users + 1)

weights = 1 / np.power(ranks, 0.75)

weights = weights / weights.sum()

# Shuffle the weights so User 1 isn't automatically
# the heaviest listener.

np.random.shuffle(weights)

# ============================================================
# ASSIGN USER_ID TO EACH REAL LISTENING EVENT
# ============================================================

history["User_id"] = np.random.choice(
    users["User_id"].values,
    size=len(history),
    p=weights
)

# ============================================================
# MAKE SIGNUP DATE CONSISTENT
# ============================================================

# Find each user's first listening date

first_listening = (
    history.groupby("User_id")["Played_at"]
    .min()
)

for index, row in users.iterrows():

    user_id = row["User_id"]

    if user_id in first_listening.index:

        first_play = first_listening[user_id]

        # User signs up 7-180 days before
        # their first recorded listening event.

        days_before = random.randint(7, 180)

        signup_date = (
    first_play - timedelta(days=days_before)
).strftime("%Y-%m-%d")

users.loc[index, "Signup_date"] = signup_date
# ============================================================
# SAVE UPDATED DATA
# ============================================================

history.to_csv(
    "data/listening_history.csv",
    index=False
)

users = pd.read_csv(
    "data/users.csv",
    parse_dates=["Signup_date"]
)

# ============================================================
# VALIDATION
# ============================================================

print("\n===== USER ASSIGNMENT COMPLETE =====")

print(
    "Listening records with User_id:",
    history["User_id"].notna().sum()
)

print(
    "Unique users who listened:",
    history["User_id"].nunique()
)

print(
    "Users with no listening records:",
    num_users - history["User_id"].nunique()
)

print("\n===== TOP LISTENERS =====")

top_users = (
    history["User_id"]
    .value_counts()
    .head(10)
)

print(top_users)

print("\n===== SAMPLE LISTENING HISTORY =====")

print(
    history.head(10).to_string(index=False)
)

print("\n===== SAMPLE USERS =====")

print(
    users.head(10).to_string(index=False)
)