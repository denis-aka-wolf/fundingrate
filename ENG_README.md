# Telegram Bot for Funding Rate Tracking

[English version](ENG_README.md) | [Русская версия](README.md)

A Telegram bot that allows tracking funding rates from Binance for various cryptocurrency pairs. The bot automatically notifies users when rates exceed a specified threshold.

## Commands

- `/start` - start working with the bot
- `/settings` - view current settings
- `/status` - check the bot status
- `/lang <language_code>` - change language (e.g., `en`, `ru`)

## Features

- Automatic funding rate checks every minute
- Configurable notification thresholds
- Notifications when funding rate thresholds are exceeded
- Multi-language support

## Localization

To generate localization files, run the following command:

```shell
dart run intl_utils:generate
```

## Mocks

To regenerate mock files for tests, run the following command:

```shell
flutter pub run build_runner build --delete-conflicting-outputs
```
