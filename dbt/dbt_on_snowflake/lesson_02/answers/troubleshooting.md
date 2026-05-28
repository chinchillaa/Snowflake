# Lesson 2 演習 模範解答: profiles.yml トラブルシューティング

## ケース A: password フィールド

**問題**: `password: "my_password123"` が存在する。

**エラーメッセージ**: `Unsupported fields found: password`

**修正**: `password` 行を削除する。Snowflake Workspace では認証は自動で処理されるため不要。

```yaml
# 修正後
dbt_learn:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: ""
      user: ""
      role: SYSADMIN
      database: DBT_LEARN
      warehouse: COMPUTE_WH
      schema: ANALYTICS
      threads: 4
```

---

## ケース B: env_var() の使用

**問題**: `{{ env_var('...') }}` を使用している。

**エラーメッセージ**: `Env var required but not provided: 'SNOWFLAKE_ACCOUNT'`

**理由**: dbt は Snowflake 内部で実行されるため、ローカル環境変数にアクセスできない。

**修正**: `env_var()` を空文字列 `""` に置き換える。

```yaml
# 修正後
      account: ""
      user: ""
```

---

## ケース C: プロファイル名の不一致

**問題**: profiles.yml のキーは `my_project:` だが、dbt_project.yml は `profile: 'dbt_learn'` を参照している。

**エラーメッセージ**: `Could not find profile named 'dbt_learn'`

**修正**: profiles.yml の最上位キーを `dbt_learn:` に変更する。

```yaml
# 修正後
dbt_learn:      # ← my_project: から変更
  target: dev
  outputs:
    ...
```

---

## 覚えるべきルール

| ルール | 理由 |
|--------|------|
| password / authenticator / private_key_path は書かない | Workspace セッションが認証を処理 |
| env_var() は使わない | Snowflake 内に環境変数がない |
| profiles.yml のキー = dbt_project.yml の profile: | 名前が一致しないと接続できない |
| schema は事前に存在が必要 | `CREATE SCHEMA IF NOT EXISTS` で先に作る |
