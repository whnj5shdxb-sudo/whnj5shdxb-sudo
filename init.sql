-- init.sql
CREATE DATABASE IF NOT EXISTS massmail;
USE massmail;

CREATE TABLE IF NOT EXISTS accounts (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  phone VARCHAR(32) NOT NULL UNIQUE,
  token_cipher BLOB NOT NULL,
  proxy_url VARCHAR(2048) NOT NULL,
  system_type VARCHAR(16) NOT NULL DEFAULT 'other',
  status ENUM('Ready', 'Dead') NOT NULL DEFAULT 'Ready',
  last_used_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  tn_session_id VARCHAR(255) NULL,
  tn_client_id VARCHAR(255) NULL,
  tn_device_model VARCHAR(255) NULL,
  tn_os VARCHAR(50) NULL,
  tn_os_version VARCHAR(50) NULL,
  tn_user_agent TEXT NULL,
  tn_type VARCHAR(50) NULL,
  tn_uuid VARCHAR(255) NULL,
  tn_vid VARCHAR(255) NULL,
  tn_session_token_cipher BLOB NULL,
  created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  KEY idx_status_last_used (status, last_used_at),
  KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS message_tasks (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  target_phone VARCHAR(32) NOT NULL,
  content TEXT NOT NULL,
  media_url TEXT NULL,
  account_id BIGINT UNSIGNED NULL,
  status ENUM('Pending','Processing','Sent','Failed','Retry','Paused') NOT NULL DEFAULT 'Pending',
  attempts INT DEFAULT 0,
  next_retry_at DATETIME(3) NULL,
  last_error TEXT NULL,
  error_code VARCHAR(64) NULL,
  error_message TEXT NULL,
  created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  processed_at DATETIME(3) NULL,
  completed_at DATETIME(3) NULL,
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE SET NULL,
  KEY idx_status (status),
  KEY idx_status_created (status, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS sub_accounts (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  parent_user_id BIGINT UNSIGNED NULL,
  quota_limit INT NOT NULL DEFAULT 10,
  status ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  FOREIGN KEY (parent_user_id) REFERENCES accounts(id) ON DELETE SET NULL,
  KEY idx_parent_user (parent_user_id),
  KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

