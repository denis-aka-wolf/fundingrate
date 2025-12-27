# Telegram Bot for Funding Rate Tracking

[English version](ENG_README.md) | [Версия на русском](README.md)

A Telegram bot that allows tracking funding rates from Binance for various cryptocurrency pairs. The bot automatically notifies users when rates exceed a specified threshold.

## Commands

- `/start` - start working with the bot
- `/settings` - view current settings
- `/add_pair <SYMBOL>` - add a trading pair to the monitored list
- `/remove_pair <SYMBOL>` - remove a trading pair from the monitored list
- `/reset_pairs` - reset the trading pair list to default values
- `/status` - check the bot status

## Features

- Automatic funding rate checks every minute
- Configurable notification thresholds
- Ability to select trading pairs for monitoring
- Notifications when funding rate thresholds are exceeded