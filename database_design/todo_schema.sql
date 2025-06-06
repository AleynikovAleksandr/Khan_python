-- Таблица проектов
CREATE TABLE project (
    name        TEXT PRIMARY KEY,
    description TEXT,
    deadline    DATE
);

-- Таблица задач
CREATE TABLE task (
    id           INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    priority     INTEGER DEFAULT 1,
    details      TEXT,
    status       TEXT,
    deadline     DATE,
    completed_on DATE,
    project      TEXT NOT NULL REFERENCES project(name)
);
