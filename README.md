\# 🎵 Music Streaming Platform with Cassandra-Based Listening History Analytics



A database-driven music streaming platform developed as a DBMS mini-project. The system uses \*\*Oracle Database\*\* for transactional and relational data management and \*\*Apache Cassandra\*\* for high-volume listening history and analytics.



\---



\## 📌 Project Overview



Music streaming platforms generate large volumes of data from users, songs, artists, albums, playlists, ratings, subscriptions, payments, and listening activity.



This project develops a simplified music streaming database that demonstrates both \*\*relational database management\*\* and \*\*NoSQL data processing\*\*.



The relational component is implemented using \*\*Oracle Database\*\*, while \*\*Cassandra\*\* is used for scalable listening-history storage and analytics.



\---



\## 🎯 Objectives



\- Design a normalized relational database for a music streaming platform.

\- Implement an EER model and convert it into relational tables.

\- Store real-world music and listening-history data.

\- Perform SQL queries for retrieval and analytics.

\- Demonstrate joins, subqueries, aggregate functions, views and DML.

\- Implement PL/SQL procedures, functions, cursors and triggers.

\- Connect the database with a Python frontend.

\- Use Cassandra for large-scale listening-history analytics.

\- Demonstrate NoSQL CRUD operations, partitioning and scalability.



\---



\## 🏗️ Database Architecture



The project follows a hybrid database architecture:



```text

&#x20;                   MUSIC STREAMING PLATFORM

&#x20;                             |

&#x20;            +----------------+----------------+

&#x20;            |                                 |

&#x20;      Oracle Database                   Apache Cassandra

&#x20;            |                                 |

&#x20;    Relational Data                 High-Volume Analytics

&#x20;            |                                 |

&#x20;    Users, Artists, Songs,          Listening History

&#x20;    Albums, Playlists,             Time-Series Events

&#x20;    Ratings, Payments,             Aggregated Analytics

&#x20;    Subscriptions

