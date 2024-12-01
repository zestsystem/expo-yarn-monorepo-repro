# expo-pnpm-monorepo

Install packages

```sh
pnpm install
```

Make sure you build package-a
```sh
cd libs/package-a
pnpm build
```

To start and verify basic app working

```sh
cd apps/mobile-sample
pnpm start
```

You will get the message "Welcome! A"
A is an enum value from package-a.

After verifying the app running, build on EAS

```sh
cd apps/mobile-sample
eas build --platform all
```

On the EAS build pipeline, the script will fail on Install Dependencies stage
from `error Couldn't find package "@utc/package-a@workspace:*" required by "mobile-sample@1.0.0" on the "npm" registry.`
