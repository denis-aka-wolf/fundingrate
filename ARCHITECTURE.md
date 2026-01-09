# Архитектура проекта

Этот документ описывает архитектуру Telegram-бота, его основные компоненты и процессы для его расширения.

## Обзор

Проект построен на принципах **Чистой архитектуры (Clean Architecture)** и использует следующие ключевые паттерны и библиотеки:

-   **Чистая архитектура**: Код разделен на три основных слоя: `domain`, `data` и `presentation`.
-   **Внедрение зависимостей (Dependency Injection)**: Используется пакет `get_it` для управления зависимостями. Вся конфигурация происходит в `lib/src/core/service_locator.dart`.
-   **Паттерн "Команда"**: Для обработки команд от пользователя используется паттерн "Команда", что делает систему гибкой и расширяемой.
-   **Управление доступом на основе ролей (RBAC)**: Доступ к командам контролируется на основе ролей пользователей (например, `user`, `admin`).

### Структура проекта

-   `lib/src/domain`: Содержит бизнес-логику приложения.
    -   `entities`: Модели данных (например, `User`, `UserSettings`).
    -   `repositories`: Абстрактные интерфейсы для репозиториев.
    -   `usecases`: Конкретные сценарии использования (бизнес-логика).
-   `lib/src/data`: Реализация слоя данных.
    -   `datasources`: Источники данных (локальные JSON-файлы, удаленные API).
    -   `repositories`: Реализации интерфейсов репозиториев из `domain`.
-   `lib/src/presentation`: Слой представления, отвечающий за взаимодействие с Telegram.
    -   `bot.dart`: Основной класс бота.
    -   `commands`: Классы для определения и регистрации команд (`BotCommand`, `CommandRegistry`).
    -   `handlers`: Функции-обработчики для конкретных команд.
    -   `keyboards`: Логика для создания и предоставления клавиатур.
-   `lib/src/core`: Вспомогательные компоненты.
    -   `service_locator.dart`: Конфигурация внедрения зависимостей.

---

## Как добавить новую команду

Добавление новой команды — это основной способ расширения функциональности бота. Процесс состоит из следующих шагов:

### 1. Создать обработчик команды

Создайте новый файл в `lib/src/presentation/handlers/`, например, `my_command_handler.dart`. В этом файле определите функцию-обработчик, которая будет выполнять логику команды.

**Пример (`lib/src/presentation/handlers/my_command_handler.dart`):**
```dart
import 'package:teledart/model.dart';
import 'package:fundingrate/src/domain/entities/user.dart';
import 'package:fundingrate/src/core/service_locator.dart';
import 'package:teledart/teledart.dart';

// Функция-обработчик
Future<void> handleMyCommand(TeleDartMessage message, UserRole userRole) async {
  final teledart = sl<TeleDart>();
  await teledart.sendMessage(message.chat.id, 'This is my new command!');
}
```

### 2. Определить и зарегистрировать команду

Откройте `lib/src/core/service_locator.dart` и добавьте новую функцию для регистрации вашей команды.

**Пример (`lib/src/core/service_locator.dart`):**

```dart
// ... другие импорты
import 'package:fundingrate/src/presentation/handlers/my_command_handler.dart';

// ...

// Новая функция для регистрации команды
void registerMyCommand(CommandRegistry registry) {
  registry.register(
    BotCommand(
      command: 'mycommand',
      description: 'Описание моей новой команды.',
      requiredRole: UserRole.user, // Минимальная роль для выполнения
      handler: handleMyCommand,
    ),
  );
}

Future<void> init() async {
  // ...

  // Command Handlers
  // ...
  registerMyCommand(sl()); // Вызовите вашу функцию регистрации
  // ...
}
```

### 3. Готово!

После перезапуска бот будет распознавать и обрабатывать новую команду `/mycommand`.

---

## Как добавить новую кнопку или клавиатуру

Кнопки на клавиатуре — это, по сути, те же команды, но с визуальным представлением. Чтобы добавить новую кнопку, выполните следующие шаги:

### 1. Создать команду с обработчиком обратного вызова (Callback)

Кнопки на клавиатуре отправляют `CallbackQuery` при нажатии. Вам нужно создать команду с `callbackHandler`.

**Пример (`lib/src/presentation/handlers/my_button_handler.dart`):**
```dart
import 'package:teledart/model.dart';
import 'package:fundingrate/src/domain/entities/user.dart';
import 'package:fundingrate/src/core/service_locator.dart';
import 'package:teledart/teledart.dart';

// Обработчик для callback'а от кнопки
Future<void> handleMyButtonCallback(CallbackQuery query, UserRole userRole) async {
  final teledart = sl<TeleDart>();
  await teledart.sendMessage(query.message!.chat.id, 'Button was pressed!');
  // Важно ответить на callback, чтобы убрать "часики" на кнопке
  await teledart.answerCallbackQuery(query.id);
}
```

### 2. Зарегистрировать команду для клавиатуры

В `lib/src/core/service_locator.dart` зарегистрируйте команду, указав, что она должна отображаться на клавиатуре.

**Пример (`lib/src/core/service_locator.dart`):**
```dart
// ... другие импорты
import 'package:fundingrate/src/presentation/handlers/my_button_handler.dart';

// ...

void registerMyButton(CommandRegistry registry) {
  registry.register(
    BotCommand(
      command: 'my_button_callback', // Уникальный идентификатор для callback'а
      description: 'Эта команда выполняется при нажатии кнопки.', // Не видна пользователю
      requiredRole: UserRole.user,
      callbackHandler: handleMyButtonCallback,
      showInKeyboard: true, // Показать на клавиатуре
      keyboardButtonText: 'Моя кнопка', // Текст на кнопке
    ),
  );
}

Future<void> init() async {
  // ...

  // Command Handlers
  // ...
  registerMyButton(sl());
  // ...
}
```

### Как это работает?

-   [`KeyboardProvider`](lib/src/presentation/keyboards/keyboard_provider.dart) автоматически находит все команды с флагом `showInKeyboard: true`.
-   Он создает `InlineKeyboardMarkup`, где `callback_data` каждой кнопки соответствует полю `command` из `BotCommand`.
-   Когда пользователь нажимает кнопку, `FundingRateBot` получает `CallbackQuery`, находит соответствующую команду в `CommandRegistry` по `callback_data` и вызывает ее `callbackHandler`.
-   Кнопки автоматически группируются по 3 в ряду.

---

## Отправка сообщений с кастомными кнопками

В некоторых случаях вам может понадобиться отправить сообщение с уникальным набором кнопок, который отличается от стандартной клавиатуры. Например, для подтверждения действия (`Да`/`Нет`).

Это делается путем создания экземпляра `InlineKeyboardMarkup` и передачи его в метод `sendMessage`.

### 1. Создайте обработчик, который отправляет сообщение с кнопками

Предположим, у нас есть команда `/confirm`, которая должна показать сообщение с кнопками "Да" и "Нет".

**Пример (`lib/src/presentation/handlers/confirm_handler.dart`):**
```dart
import 'package:teledart/model.dart';
import 'package:fundingrate/src/domain/entities/user.dart';
import 'package:fundingrate/src/core/service_locator.dart';
import 'package:teledart/teledart.dart';

// Функция-обработчик для команды /confirm
Future<void> handleConfirmCommand(TeleDartMessage message, UserRole userRole) async {
  final teledart = sl<TeleDart>();

  // Создаем клавиатуру
  final keyboard = InlineKeyboardMarkup(
    inlineKeyboard: [
      [ // Первый ряд кнопок
        InlineKeyboardButton(
          text: '✅ Да',
          callbackData: 'confirm_yes', // Уникальный callback
        ),
        InlineKeyboardButton(
          text: '❌ Нет',
          callbackData: 'confirm_no', // Уникальный callback
        ),
      ],
    ],
  );

  // Отправляем сообщение с клавиатурой
  await teledart.sendMessage(
    message.chat.id,
    'Вы уверены, что хотите выполнить это действие?',
    replyMarkup: keyboard,
  );
}
```

### 2. Создайте обработчики для кастомных callback'ов

Теперь вам нужно зарегистрировать команды, которые будут обрабатывать `callbackData` (`confirm_yes` и `confirm_no`). Эти команды не будут видны пользователям и не будут отображаться на основной клавиатуре.

**Пример (`lib/src/presentation/handlers/confirm_handler.dart`):**
```dart
// ... (handleConfirmCommand выше)

// Обработчик для "Да"
Future<void> handleConfirmYes(CallbackQuery query, UserRole userRole) async {
  final teledart = sl<TeleDart>();
  // Редактируем исходное сообщение, чтобы убрать кнопки
  await teledart.editMessageText(
    'Действие подтверждено.',
    chatId: query.message!.chat.id,
    messageId: query.message!.messageId,
  );
  await teledart.answerCallbackQuery(query.id);
}

// Обработчик для "Нет"
Future<void> handleConfirmNo(CallbackQuery query, UserRole userRole) async {
  final teledart = sl<TeleDart>();
  await teledart.editMessageText(
    'Действие отменено.',
    chatId: query.message!.chat.id,
    messageId: query.message!.messageId,
  );
  await teledart.answerCallbackQuery(query.id);
}
```

### 3. Зарегистрируйте все команды в `service_locator.dart`

```dart
// ... другие импорты
import 'package:fundingrate/src/presentation/handlers/confirm_handler.dart';

// ...

void registerConfirmCommands(CommandRegistry registry) {
  // 1. Основная команда /confirm
  registry.register(
    BotCommand(
      command: 'confirm',
      description: 'Запрашивает подтверждение.',
      handler: handleConfirmCommand,
    ),
  );

  // 2. Callback для кнопки "Да"
  registry.register(
    BotCommand(
      command: 'confirm_yes',
      description: 'Обработчик подтверждения (скрыт).',
      callbackHandler: handleConfirmYes,
    ),
  );

  // 3. Callback для кнопки "Нет"
  registry.register(
    BotCommand(
      command: 'confirm_no',
      description: 'Обработчик отмены (скрыт).',
      callbackHandler: handleConfirmNo,
    ),
  );
}

Future<void> init() async {
  // ...

  // Command Handlers
  // ...
  registerConfirmCommands(sl());
  // ...
}
```

Таким образом, вы можете создавать сложные интерактивные сценарии, прикрепляя кастомные клавиатуры к своим сообщениям.