# Aarogya Supabase project

Use this for account isolation and optional refresh persistence. Inference stays on the device.

## Create the project

1. Create a Supabase project.
2. In Authentication → Providers, keep Email enabled. Disable social login and magic links.
3. Turn **Confirm email** off for the SIH demo so judges can register and sign in immediately.
4. Authentication → URL configuration:
   - Site URL: the Vercel origin (or `http://localhost:8090` while developing)
   - Redirect allowlist: `http://localhost:*`, the Vercel origin, and any preview origins
5. SQL Editor: run [`migrations/20260906_aarogya_accounts.sql`](migrations/20260906_aarogya_accounts.sql).

## Keys

Ship only:

- Project URL
- Publishable / anon key

Never put the service-role key in Flutter, Vercel client env, or git.

Local / Vercel dart-defines:

```text
SUPABASE_URL=https://YOUR_PROJECT.supabase.co
SUPABASE_ANON_KEY=YOUR_PUBLISHABLE_ANON_KEY
```

`tool/vercel_build.sh` forwards those environment variables into the web build when they are set. Both are optional. Leave them unset for the offline/local-account demo.

## Row Level Security

Every public table enables RLS. `anon` has no table grants. Authenticated policies require `user_id = auth.uid()`.

A second signed-in user cannot read the first user's observations, baseline, snapshot, or packets.
