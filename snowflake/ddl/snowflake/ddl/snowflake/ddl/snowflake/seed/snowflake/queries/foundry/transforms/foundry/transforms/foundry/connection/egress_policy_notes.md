# Foundry Egress Policy — Snowflake Connection Notes

## Why This Is Needed

Palantir Foundry's network sandbox blocks all outbound connections by default. To connect Foundry to an external Snowflake account, an **Egress Policy** must be explicitly configured to whitelist the Snowflake endpoint.

---

## Steps to Configure

### 1. Locate Egress Policy Settings
- In Foundry: **Control Panel** → **Infrastructure** → **Egress Policies**
- Or via: **Data Connection** → **Source** → **Edit** → **Network**

### 2. Add Snowflake Hostname Rule

| Field | Value |
|---|---|
| Rule Name | `snowflake-aavya-training` |
| Host | `<orgname>-<accountname>.snowflakecomputing.com` |
| Port | `443` |
| Protocol | `HTTPS` |

> ⚠️ Use the **org-account** format, NOT the legacy `<account>.us-east-1.snowflakecomputing.com` format.
> Find your identifier in Snowflake: `SELECT CURRENT_ACCOUNT(), CURRENT_ORGANIZATION_NAME();`

### 3. Apply & Test
1. Save the egress rule
2. Return to the Snowflake Data Connection
3. Click **Test Connection**
4. If successful, trigger a **Sync Build**

---

## Common Errors

| Error | Cause | Fix |
|---|---|---|
| `Connection timed out` | Egress policy not applied | Add hostname rule above |
| `Account not found` | Wrong account identifier format | Use `org-account` format |
| `SSL handshake failed` | Port 443 blocked | Verify port in egress rule |
| `Infrastructure error` during build | Cross-region latency (Azure Central IN) | Retry; contact Foundry support if persistent |

---

## Account Identifier Reference

```sql
-- Run in Snowflake to get your account details
SELECT
    CURRENT_ORGANIZATION_NAME() AS org_name,
    CURRENT_ACCOUNT()           AS account_name,
    CURRENT_REGION()            AS region;

-- Your connection string will be:
-- <org_name>-<account_name>.snowflakecomputing.com
```

