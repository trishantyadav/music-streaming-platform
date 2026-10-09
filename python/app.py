import streamlit as st
import oracledb

from db_config import ORACLE_USER, ORACLE_PASSWORD, ORACLE_DSN


# ============================================================
# DATABASE CONNECTION
# ============================================================

@st.cache_resource
def get_connection():
    return oracledb.connect(
        user=ORACLE_USER,
        password=ORACLE_PASSWORD,
        dsn=ORACLE_DSN
    )


def run_query(query, params=None):
    conn = get_connection()

    with conn.cursor() as cursor:
        cursor.execute(query, params or {})

        columns = [col[0] for col in cursor.description]
        rows = cursor.fetchall()

    return columns, rows


# ============================================================
# HELPER FUNCTIONS
# ============================================================

def get_users():

    query = """
        SELECT
            User_id,
            Name,
            Email
        FROM USERS
        ORDER BY User_id
    """

    _, rows = run_query(query)
    return rows


def get_songs(keyword=""):

    query = """
        SELECT
            s.Song_id,
            s.Title AS Song_Name,
            ar.Name AS Artist_Name,
            al.Title AS Album_Name,
            s.Duration
        FROM SONG s
        JOIN ALBUM al
            ON s.Album_id = al.Album_id
        JOIN ARTIST ar
            ON al.Artist_id = ar.Artist_id
        WHERE LOWER(s.Title) LIKE LOWER(:keyword)
        ORDER BY s.Title
        FETCH FIRST 100 ROWS ONLY
    """

    _, rows = run_query(
        query,
        {"keyword": f"%{keyword}%"}
    )

    return rows


def user_dropdown(key):

    users = get_users()

    user_options = {
        f"{row[1]} — {row[2]}": row[0]
        for row in users
    }

    selected = st.selectbox(
        "Select User",
        list(user_options.keys()),
        key=key
    )

    return user_options[selected]


# ============================================================
# PAGE CONFIGURATION
# ============================================================

st.set_page_config(
    page_title="Music Streaming Platform",
    page_icon="🎵",
    layout="wide"
)

st.title("🎵 Music Streaming Platform")
st.caption("Explore songs, users, listening history and ratings")


# ============================================================
# SIDEBAR
# ============================================================

st.sidebar.header("Navigation")

option = st.sidebar.selectbox(
    "Select Operation",
    [
        "🔎 Search Songs",
        "👤 User Details",
        "🎧 Listening History",
        "📊 Listening Statistics",
        "⭐ User Ratings",
        "➕ Add Rating",
        "✏️ Update Rating"
    ]
)


# ============================================================
# 1. SEARCH SONGS
# ============================================================

if option == "🔎 Search Songs":

    st.header("🔎 Search Songs")

    st.write(
        "Search the music catalogue by song title."
    )

    keyword = st.text_input(
        "Song Name",
        placeholder="Example: Believer"
    )

    if st.button("🔎 Search"):

        if not keyword.strip():

            st.warning(
                "Please enter a song name."
            )

        else:

            songs = get_songs(keyword)

            if songs:

                display_data = []

                for row in songs:

                    duration_minutes = round(
                        row[4] / 60000, 2
                    )

                    display_data.append({
                        "Song": row[1],
                        "Artist": row[2],
                        "Album": row[3],
                        "Duration (minutes)": duration_minutes
                    })

                st.dataframe(
                    display_data,
                    use_container_width=True
                )

                st.success(
                    f"{len(songs)} song(s) found."
                )

            else:

                st.info(
                    "No songs found."
                )


# ============================================================
# 2. USER DETAILS
# ============================================================

elif option == "👤 User Details":

    st.header("👤 User Details")

    st.write(
        "View information about a registered user."
    )

    user_id = user_dropdown(
        "user_details"
    )

    if st.button("View User"):

        query = """
            SELECT
                User_id,
                Name,
                Email,
                Country,
                Signup_date
            FROM USERS
            WHERE User_id = :user_id
        """

        columns, rows = run_query(
            query,
            {"user_id": user_id}
        )

        if rows:

            data = [
                dict(zip(columns, row))
                for row in rows
            ]

            st.dataframe(
                data,
                use_container_width=True
            )


# ============================================================
# 3. LISTENING HISTORY
# ============================================================

elif option == "🎧 Listening History":

    st.header("🎧 User Listening History")

    st.write(
        "View songs listened to by a selected user."
    )

    user_id = user_dropdown(
        "history_user"
    )

    limit = st.selectbox(
        "Number of records",
        [20, 50, 100]
    )

    if st.button("View Listening History"):

        query = """
            SELECT
                lh.Played_at,
                s.Title AS Song_Name,
                ar.Name AS Artist_Name,
                al.Title AS Album_Name,
                ROUND(
                    lh.Duration_played / 60000,
                    2
                ) AS Minutes_Listened
            FROM LISTENING_HISTORY lh
            JOIN SONG s
                ON lh.Song_id = s.Song_id
            JOIN ALBUM al
                ON s.Album_id = al.Album_id
            JOIN ARTIST ar
                ON al.Artist_id = ar.Artist_id
            WHERE lh.User_id = :user_id
            ORDER BY lh.Played_at DESC
            FETCH FIRST 100 ROWS ONLY
        """

        columns, rows = run_query(
            query,
            {"user_id": user_id}
        )

        if rows:

            data = [
                dict(zip(columns, row))
                for row in rows[:limit]
            ]

            st.dataframe(
                data,
                use_container_width=True
            )

            st.success(
                f"Showing {len(data)} listening records."
            )

        else:

            st.info(
                "No listening history found."
            )


# ============================================================
# 4. LISTENING STATISTICS
# ============================================================

elif option == "📊 Listening Statistics":

    st.header("📊 User Listening Statistics")

    st.write(
        "View cumulative listening activity from the stored history."
    )

    user_id = user_dropdown(
        "stats_user"
    )

    if st.button("📊 Calculate Statistics"):

        query = """
            SELECT
                COUNT(*) AS TOTAL_PLAYS,
                ROUND(
                    SUM(Duration_played) / 60000,
                    2
                ) AS TOTAL_MINUTES,
                ROUND(
                    AVG(Duration_played) / 60000,
                    2
                ) AS AVG_MINUTES_PER_PLAY
            FROM LISTENING_HISTORY
            WHERE User_id = :user_id
        """

        _, rows = run_query(
            query,
            {"user_id": user_id}
        )

        if rows:

            total_plays = rows[0][0] or 0
            total_minutes = rows[0][1] or 0
            avg_minutes = rows[0][2] or 0

            col1, col2, col3 = st.columns(3)

            col1.metric(
                "🎵 Total Plays",
                total_plays
            )

            col2.metric(
                "⏱️ Total Listening Time",
                f"{total_minutes} min"
            )

            col3.metric(
                "📈 Avg. Time / Play",
                f"{avg_minutes} min"
            )


# ============================================================
# 5. USER RATINGS
# ============================================================

elif option == "⭐ User Ratings":

    st.header("⭐ User Ratings")

    st.write(
        "Monitor the ratings and reviews submitted by a user."
    )

    user_id = user_dropdown(
        "ratings_user"
    )

    if st.button("⭐ View Ratings"):

        query = """
            SELECT
                s.Title AS Song_Name,
                ar.Name AS Artist_Name,
                r.Rating,
                r.Review_text,
                r.Rated_at
            FROM RATING r
            JOIN SONG s
                ON r.Song_id = s.Song_id
            JOIN ALBUM al
                ON s.Album_id = al.Album_id
            JOIN ARTIST ar
                ON al.Artist_id = ar.Artist_id
            WHERE r.User_id = :user_id
            ORDER BY r.Rated_at DESC
        """

        columns, rows = run_query(
            query,
            {"user_id": user_id}
        )

        if rows:

            data = [
                dict(zip(columns, row))
                for row in rows
            ]

            st.dataframe(
                data,
                use_container_width=True
            )

            st.success(
                f"{len(rows)} rating(s) found."
            )

        else:

            st.info(
                "This user has not submitted any ratings."
            )


# ============================================================
# 6. ADD RATING — DML INSERT
# ============================================================

elif option == "➕ Add Rating":

    st.header("➕ Add Rating")

    st.info(
        "DML Demonstration — INSERT a new rating into the RATING table."
    )

    user_id = user_dropdown(
        "insert_user"
    )

    song_keyword = st.text_input(
        "Search Song",
        placeholder="Example: Believer",
        key="insert_song_search"
    )

    if song_keyword:

        songs = get_songs(song_keyword)

        if songs:

            song_options = {
                f"{row[1]} — {row[2]} — {row[3]}": row[0]
                for row in songs
            }

            selected_song = st.selectbox(
                "Select Song",
                list(song_options.keys()),
                key="insert_song"
            )

            song_id = song_options[selected_song]

            # Check whether the user already rated it

            _, existing = run_query(
                """
                SELECT Rating
                FROM RATING
                WHERE User_id = :user_id
                  AND Song_id = :song_id
                """,
                {
                    "user_id": user_id,
                    "song_id": song_id
                }
            )

            if existing:

                st.warning(
                    "This user has already rated this song. "
                    "Use Update Rating instead."
                )

            else:

                rating = st.slider(
                    "Rating",
                    1,
                    5,
                    5,
                    key="insert_rating"
                )

                review = st.text_area(
                    "Review",
                    key="insert_review"
                )

                if st.button(
                    "➕ Insert Rating"
                ):

                    conn = get_connection()

                    try:

                        with conn.cursor() as cursor:

                            cursor.execute(
                                """
                                INSERT INTO RATING (
                                    Rating_id,
                                    User_id,
                                    Song_id,
                                    Rating,
                                    Review_text,
                                    Rated_at
                                )
                                VALUES (
                                    RATING_SEQ.NEXTVAL,
                                    :user_id,
                                    :song_id,
                                    :rating,
                                    :review,
                                    SYSDATE
                                )
                                """,
                                {
                                    "user_id": user_id,
                                    "song_id": song_id,
                                    "rating": rating,
                                    "review": review
                                }
                            )

                        conn.commit()

                        st.success(
                            "✅ Rating inserted successfully."
                        )

                    except oracledb.Error as e:

                        conn.rollback()

                        st.error(
                            f"Insert failed: {e}"
                        )

        else:

            st.info(
                "No matching songs found."
            )


# ============================================================
# 7. UPDATE RATING — DML UPDATE
# ============================================================

elif option == "✏️ Update Rating":

    st.header("✏️ Update Rating")

    st.info(
        "DML Demonstration — UPDATE an existing rating in the RATING table."
    )

    user_id = user_dropdown(
        "update_user"
    )

    song_keyword = st.text_input(
        "Search Song",
        placeholder="Example: Believer",
        key="update_song_search"
    )

    if song_keyword:

        songs = get_songs(song_keyword)

        if songs:

            song_options = {
                f"{row[1]} — {row[2]} — {row[3]}": row[0]
                for row in songs
            }

            selected_song = st.selectbox(
                "Select Song",
                list(song_options.keys()),
                key="update_song"
            )

            song_id = song_options[selected_song]

            query = """
                SELECT
                    Rating,
                    Review_text,
                    Rated_at
                FROM RATING
                WHERE User_id = :user_id
                  AND Song_id = :song_id
            """

            _, rows = run_query(
                query,
                {
                    "user_id": user_id,
                    "song_id": song_id
                }
            )

            if rows:

                current_rating = rows[0][0]
                current_review = rows[0][1]
                rated_at = rows[0][2]

                st.success(
                    "Existing rating found!"
                )

                col1, col2 = st.columns(2)

                col1.metric(
                    "⭐ Current Rating",
                    f"{current_rating} / 5"
                )

                col2.write(
                    f"**Rated On:** {rated_at}"
                )

                st.write(
                    f"**Current Review:** "
                    f"{current_review or 'No review'}"
                )

                st.divider()

                new_rating = st.slider(
                    "New Rating",
                    1,
                    5,
                    current_rating,
                    key="new_rating"
                )

                new_review = st.text_area(
                    "Update Review",
                    value=current_review or "",
                    key="new_review"
                )

                if st.button(
                    "✏️ Update Rating"
                ):

                    conn = get_connection()

                    try:

                        with conn.cursor() as cursor:

                            cursor.execute(
                                """
                                UPDATE RATING
                                SET
                                    Rating = :rating,
                                    Review_text = :review,
                                    Rated_at = SYSDATE
                                WHERE User_id = :user_id
                                  AND Song_id = :song_id
                                """,
                                {
                                    "rating": new_rating,
                                    "review": new_review,
                                    "user_id": user_id,
                                    "song_id": song_id
                                }
                            )

                            affected = cursor.rowcount

                        conn.commit()

                        if affected > 0:

                            st.success(
                                "✅ Rating updated successfully."
                            )

                    except oracledb.Error as e:

                        conn.rollback()

                        st.error(
                            f"Update failed: {e}"
                        )

            else:

                st.warning(
                    "This user has not rated this song yet."
                )

                st.info(
                    "Use 'Add Rating' to insert a new rating."
                )