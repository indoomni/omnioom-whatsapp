## Project Overview

This is a WhatsApp bot built with Node.js and the Baileys library. It's designed to be modular, with a clear separation of commands and event handlers. The bot's configuration is managed through a `bot.yml` file, allowing for easy customization of its behavior.

**Key Technologies:**

*   **Node.js:** The runtime environment for the bot.
*   **Baileys:** A library for interacting with the WhatsApp Web API.
*   **pino:** Used for logging.
*   **js-yaml:** Used for parsing the `bot.yml` configuration file.

**Architecture:**

*   `index.js`: The main entry point of the application. It initializes the bot, loads commands and events, and connects to WhatsApp.
*   `commands/`: This directory contains individual command modules. Each file defines a command's name and its execution logic.
*   `events/`: This directory contains event handler modules. Each file defines an event to listen for (e.g., new messages, connection updates) and the logic to handle it.
*   `utils.js`: A utility file that loads the `bot.yml` configuration.
*   `bot.yml`: A YAML file for configuring the bot's settings.

## Building and Running

**1. Install Dependencies:**

```bash
yarn install
```

**2. Start the Bot:**

```bash
yarn start
```

Upon starting, the bot will generate a QR code in the terminal. You need to scan this QR code with your WhatsApp mobile app to link the bot to your account.

## Development Conventions

*   **Commands:** New commands should be added as new files in the `commands/` directory. Each command file should export an object with `name` and `handler` properties.
*   **Events:** New event handlers should be added as new files in the `events/` directory. Each event file should export an object with `eventName` and `handler` properties.
*   **Configuration:** The `bot.yml` file should be used for any configurable values. The `utils.js` file will automatically load these values.
*   **Logging:** The `pino` logger is used for logging. You can adjust the log level in the `bot.yml` file.
