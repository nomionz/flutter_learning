const idCol = 'id';
const emailCol = 'email';
const userIdCol = 'user_id';
const textCol = 'text';
const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user"(
          "id"	INTEGER NOT NULL,
          "email"	TEXT NOT NULL UNIQUE,
          PRIMARY KEY("id" AUTOINCREMENT)
        );''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "notes" (
          "id"	INTEGER NOT NULL,
          "user_id"	INTEGER,
          "text"	TEXT,
          PRIMARY KEY("id" AUTOINCREMENT),
          FOREIGN KEY("user_id") REFERENCES "user"("id")
        );''';
