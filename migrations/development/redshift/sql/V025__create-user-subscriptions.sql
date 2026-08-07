CREATE TABLE IF NOT EXISTS
  subscription_.user_subscription (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    report_id TEXT NOT NULL,
    report_variant_id TEXT NOT NULL,
    status TEXT NOT NULL,
    created_time TIMESTAMP DEFAULT SYSDATE,
    updated_time TIMESTAMP
  ) DISTSTYLE KEY DISTKEY(id);
