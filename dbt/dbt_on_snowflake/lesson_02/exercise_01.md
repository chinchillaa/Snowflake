# Lesson 2 — 演習: profiles.yml のトラブルシューティング

> **難易度**: ★☆☆ 基本  
> **目的**: profiles.yml のエラーパターンを理解し、修正できるようになる

---

## 問題

以下の `profiles.yml` にはそれぞれ **1つのエラー** がある。  
エラーを特定し、正しく修正せよ。

### ケース A

```yaml
dbt_learn:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: ""
      user: ""
      password: "my_password123"
      role: SYSADMIN
      database: DBT_LEARN
      warehouse: COMPUTE_WH
      schema: ANALYTICS
      threads: 4
```

**質問**: 何が問題か？ どう修正すべきか？

### ケース B

```yaml
dbt_learn:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: "{{ env_var('SNOWFLAKE_ACCOUNT') }}"
      user: "{{ env_var('SNOWFLAKE_USER') }}"
      role: SYSADMIN
      database: DBT_LEARN
      warehouse: COMPUTE_WH
      schema: ANALYTICS
      threads: 4
```

**質問**: Workspace 環境でこれを使うとどうなるか？

### ケース C

```yaml
my_project:
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

`dbt_project.yml` は `profile: 'dbt_learn'` と設定されている。

**質問**: `dbt parse` を実行するとどんなエラーが出るか？

---

## 検証

修正後の profiles.yml で `dbt parse` がエラーなく通ることを確認する。

---

模範解答 → [answers/troubleshooting.md](answers/troubleshooting.md)
