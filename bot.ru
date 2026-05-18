import telebot
import os
import random
from collections import deque
from telebot import types

TOKEN = os.environ.get('TOKEN')
bot = telebot.TeleBot(TOKEN)

# ========== TOPIC VOCABULARY ==========
topic_vocab = {
    3: {
        "beat": "побеждать",
        "board game": "настольная игра",
        "captain": "капитан",
        "challenge": "вызов",
        "champion": "чемпион",
        "cheat": "жульничать",
        "classical music": "классическая музыка",
        "club": "клуб",
        "coach": "тренер",
        "competition": "соревнование",
        "concert": "концерт",
        "defeat": "поражение",
        "entertaining": "развлекательный",
        "folk music": "народная музыка",
        "group": "музыкальная группа",
        "gym": "спортзал",
        "have fun": "веселиться",
        "member": "член команды",
        "opponent": "соперник",
        "organise": "организовывать",
        "pleasure": "удовольствие",
        "referee": "судья",
        "rhythm": "ритм",
        "risk": "риск",
        "score": "счёт",
        "support": "поддерживать",
        "team": "команда",
        "train": "тренироваться",
        "video game": "видеоигра"
    },
    6: {
        "achieve": "достигать",
        "brain": "мозг",
        "clever": "умный",
        "concentrate": "концентрироваться",
        "consider": "рассматривать",
        "course": "курс",
        "degree": "учёная степень",
        "experience": "опыт",
        "expert": "эксперт",
        "fail": "провалиться",
        "guess": "догадываться",
        "hesitate": "колебаться",
        "instruction": "инструкция",
        "make progress": "делать успехи",
        "make sure": "убедиться",
        "mark": "оценка",
        "mental": "умственный",
        "pass": "сдать экзамен",
        "qualification": "квалификация",
        "remind": "напоминать",
        "report": "отчёт",
        "revise": "повторять материал",
        "search": "искать",
        "skill": "навык",
        "smart": "сообразительный",
        "subject": "школьный предмет",
        "take an exam": "сдавать экзамен",
        "talented": "талантливый",
        "term": "семестр",
        "wonder": "задаваться вопросом"
    },
    9: {
        "abroad": "за границей",
        "accommodation": "жильё",
        "book": "бронировать",
        "cancel": "отменять",
        "catch": "успеть на транспорт",
        "coach": "междугородний автобус",
        "convenient": "удобный",
        "crash": "авария",
        "crowded": "переполненный",
        "cruise": "круиз",
        "delay": "задержка",
        "destination": "пункт назначения",
        "ferry": "паром",
        "flight": "рейс",
        "foreign": "иностранный",
        "harbour": "гавань",
        "journey": "путешествие",
        "luggage": "багаж",
        "nearby": "поблизости",
        "pack": "упаковывать вещи",
        "passport": "паспорт",
        "platform": "платформа",
        "public transport": "общественный транспорт",
        "reach": "добираться",
        "resort": "курорт",
        "souvenir": "сувенир",
        "traffic": "дорожное движение",
        "trip": "поездка",
        "vehicle": "транспортное средство"
    },
    12: {
        "apologise": "извиняться",
        "close": "близкий",
        "confident": "уверенный",
        "couple": "пара",
        "defend": "защищать",
        "divorced": "разведённый",
        "generous": "щедрый",
        "grateful": "благодарный",
        "independent": "независимый",
        "introduce": "представлять",
        "loyal": "верный",
        "mood": "настроение",
        "neighbourhood": "район",
        "ordinary": "обычный",
        "patient": "терпеливый",
        "private": "скрытный",
        "recognise": "узнавать",
        "rent": "арендовать",
        "respect": "уважать",
        "single": "холостой",
        "stranger": "незнакомец",
        "trust": "доверять"
    },
    15: {
        "afford": "позволить себе",
        "bargain": "выгодная покупка",
        "brand": "бренд",
        "catalogue": "каталог",
        "change": "сдача",
        "coin": "монета",
        "cost": "стоимость",
        "customer": "покупатель",
        "deal": "сделка",
        "discount": "скидка",
        "exchange": "обмен",
        "expensive": "дорогой",
        "fashion": "мода",
        "item": "товар",
        "label": "этикетка",
        "luxury": "роскошь",
        "material": "материал",
        "online shopping": "онлайн-покупки",
        "payment": "оплата",
        "pocket money": "карманные деньги",
        "price": "цена",
        "purchase": "покупка",
        "receipt": "чек",
        "refund": "возврат денег",
        "sale": "распродажа",
        "second-hand": "подержанный",
        "shop assistant": "продавец",
        "style": "стиль",
        "trend": "тренд",
        "value": "ценность"
    }
}

# ========== ФРАЗОВЫЕ ГЛАГОЛЫ ==========
phrasal_verbs = {
    3: {
        "carry on": "продолжать",
        "give up": "бросать",
        "take up": "начинать заниматься",
        "turn down": "отклонять",
        "turn up": "появляться",
        "join in": "присоединяться",
        "eat out": "есть вне дома"
    },
    6: {
        "cross out": "зачёркивать",
        "look up": "искать в словаре",
        "point out": "указывать",
        "read out": "зачитывать вслух",
        "write down": "записывать",
        "rub out": "стирать",
        "find out": "узнавать",
        "hand in": "сдавать работу"
    },
    9: {
        "get off": "выходить из транспорта",
        "get on": "заходить в транспорт",
        "set off": "отправляться",
        "take off": "взлетать",
        "go away": "уезжать",
        "go back": "возвращаться",
        "check in": "регистрироваться",
        "pick up": "забирать"
    },
    12: {
        "fall out": "поссориться",
        "make up": "мириться",
        "get on with": "ладить с",
        "look after": "заботиться о",
        "grow up": "вырастать",
        "bring up": "воспитывать"
    }
}

# ========== ПРЕДЛОЖНЫЕ ФРАЗЫ ==========
prepositional_phrases = {
    3: {
        "in the middle of": "в середине",
        "in time for": "вовремя для",
        "on stage": "на сцене",
        "for fun": "для удовольствия",
        "for a long time": "долго"
    },
    6: {
        "by heart": "наизусть",
        "in fact": "на самом деле",
        "in general": "в общем",
        "for instance": "например",
        "in conclusion": "в заключение"
    },
    9: {
        "on time": "вовремя",
        "in advance": "заранее",
        "by mistake": "по ошибке",
        "on holiday": "в отпуске",
        "at the airport": "в аэропорту"
    }
}

# ========== СЛОВОСОЧЕТАНИЯ ==========
word_patterns = {
    3: {
        "interested in": "интересоваться",
        "good at": "быть хорошим в",
        "bored with": "скучать от",
        "crazy about": "без ума от",
        "keen on": "увлекаться"
    },
    6: {
        "capable of": "способен на",
        "cope with": "справляться с",
        "succeed in": "преуспевать в",
        "confuse with": "путать с"
    },
    9: {
        "arrive at": "прибывать в",
        "depend on": "зависеть от",
        "apply for": "подавать заявку на"
    }
}

# ========== ПРИЛАГАТЕЛЬНЫЕ + ПРЕДЛОГИ ==========
adj_prep = {
    "addicted to": "зависимый от",
    "afraid of": "боящийся",
    "aware of": "знающий о",
    "bored with": "скучающий от",
    "capable of": "способный на",
    "close to": "близкий к",
    "concerned about": "обеспокоенный",
    "covered with": "покрытый",
    "dedicated to": "преданный",
    "dependent on": "зависимый от",
    "devoted to": "преданный",
    "different from": "отличающийся от",
    "eager for": "желающий",
    "enthusiastic about": "увлечённый",
    "equipped with": "оборудованный",
    "familiar with": "знакомый с",
    "famous for": "известный",
    "filled with": "наполненный",
    "fond of": "любящий",
    "full of": "полный",
    "good at": "хороший в",
    "grateful to": "благодарный",
    "happy about": "радостный по поводу",
    "harmful to": "вредный для",
    "interested in": "заинтересованный в",
    "involved in": "участвующий в",
    "keen on": "увлечённый",
    "known for": "известный за",
    "limited to": "ограниченный",
    "optimistic about": "оптимистичный насчёт",
    "packed with": "переполненный",
    "passionate about": "страстно увлечённый",
    "pleased with": "довольный",
    "popular with": "популярный среди",
    "prepared for": "готовый к",
    "proud of": "гордый",
    "responsible for": "ответственный за",
    "satisfied with": "удовлетворённый",
    "sensitive to": "чувствительный к",
    "serious about": "серьёзно настроенный",
    "similar to": "похожий на",
    "skilled at": "умелый в",
    "suitable for": "подходящий для",
    "thankful for": "благодарный за",
    "typical of": "типичный для",
    "upset about": "расстроенный из-за",
    "worried about": "обеспокоенный",
    "worthy of": "достойный"
}

# ========== ГЛАГОЛЫ + ПРЕДЛОГИ ==========
verb_prep = {
    "aim at": "нацелиться на",
    "appeal to": "нравиться",
    "apply for": "подать заявление",
    "approve of": "одобрять",
    "ask for": "просить",
    "charge for": "брать деньги за",
    "concentrate on": "концентрироваться на",
    "congratulate on": "поздравлять с",
    "consist of": "состоять из",
    "contribute to": "вносить вклад в",
    "cope with": "справляться с",
    "deal with": "иметь дело с",
    "depend on": "зависеть от",
    "discourage from": "отговаривать от",
    "focus on": "сосредоточиться на",
    "lead to": "привести к",
    "object to": "возражать против",
    "prevent from": "не давать сделать",
    "provide with": "предоставлять",
    "refer to": "обращаться к",
    "rely on": "полагаться на",
    "remind of": "напоминать о",
    "result in": "привести к",
    "spend on": "тратить на",
    "succeed in": "преуспеть в",
    "wait for": "ждать"
}

# ========== УСТОЙЧИВЫЕ ФРАЗЫ ==========
phrases = {
    "arrive at a conclusion": "прийти к выводу",
    "be in charge of": "быть ответственным за",
    "be in favour of": "поддерживать",
    "bear in mind": "помнить",
    "draw attention to": "привлекать внимание к",
    "fall in love with": "влюбиться в",
    "get rid of": "избавляться от",
    "get used to": "привыкнуть к",
    "have an effect on": "оказывать влияние на",
    "have in common with": "иметь общее с",
    "keep an eye on": "следить за",
    "keep in touch with": "поддерживать связь с",
    "make up one's mind": "принять решение",
    "pay attention to": "обращать внимание на",
    "take part in": "принимать участие в",
    "take pride in": "гордиться",
    "turn out to be": "оказаться",
    "make a difference": "иметь значение",
    "run out of": "закончиться",
    "look forward to": "с нетерпением ждать"
}


# ========== ТРЕКЕР ВОПРОСОВ ==========
class ТрекерВопросов:
    def __init__(self, максимум_истории=50):
        self.история = deque(maxlen=максимум_истории)
        self.последний_вопрос_пользователя = {}

    def был_недавно_задан(self, uid, хэш):
        return self.последний_вопрос_пользователя.get(uid) == хэш

    def отметить(self, uid, хэш):
        self.последний_вопрос_пользователя[uid] = хэш
        self.история.append((uid, хэш))


трекер = ТрекерВопросов()


# ========== УТИЛИТЫ ==========
def очистить_текст(текст):
    для_удаления = [" sth", " sb", "(sth)", "(sb)", " / sth", " / sb",
                    "/ sth", "/ sb", " sth/sb", "(sth/sb)"]
    for фраза in для_удаления:
        текст = текст.replace(фраза, "")
    return текст.strip()


def собрать_все_данные():
    все_слова = {}
    for unit, words in topic_vocab.items():
        все_слова.update(words)
    все_фразовые = {}
    for unit, verbs in phrasal_verbs.items():
        все_фразовые.update(verbs)
    все_предлоги = {}
    for unit, d in prepositional_phrases.items():
        все_предлоги.update(d)
    все_паттерны = {}
    for unit, d in word_patterns.items():
        все_паттерны.update(d)
    все_паттерны.update(adj_prep)
    все_фразы = dict(phrases)
    return {
        'словарь': все_слова,
        'фразовые': все_фразовые,
        'предлоги': все_предлоги,
        'паттерны': все_паттерны,
        'adj_prep': adj_prep,
        'verb_prep': verb_prep,
        'фразы': все_фразы
    }


ВСЕ_ДАННЫЕ = собрать_все_данные()


# ========== ГЕНЕРАЦИЯ ВАРИАНТОВ ==========
def варианты_из_значений(правильный, словарь, n=4):
    пул = [очистить_текст(з) for з in словарь.values() if з != правильный]
    random.shuffle(пул)
    варианты = пул[:n]
    варианты.append(очистить_текст(правильный))
    random.shuffle(варианты)
    return варианты


def варианты_предлогов(правильный, n=4):
    предлоги = ['in', 'on', 'at', 'for', 'of', 'to', 'with', 'by', 'from', 'about', 'into', 'through']
    варианты = [п for п in предлоги if п != правильный]
    random.shuffle(варианты)
    return варианты[:n] + [правильный]


# ========== ГЕНЕРАЦИЯ ВОПРОСОВ ==========
def вопрос_словарь(слово, перевод, все):
    return {
        "текст": f"Переведите на русский:\n\n<b>{слово}</b>",
        "правильный": очистить_текст(перевод),
        "варианты": варианты_из_значений(перевод, все)
    }


def вопрос_фразовый_перевод(глагол, значение, все):
    return {
        "текст": f"Переведите фразовый глагол:\n\n<b>{глагол}</b>",
        "правильный": очистить_текст(значение),
        "варианты": варианты_из_значений(значение, все)
    }


def вопрос_предлог(фраза, предлог, значение):
    чистая = фраза.replace(f" {предлог}", " ___")
    if "___" not in чистая:
        чистая = фраза.replace(предлог, "___", 1)
    return {
        "текст": f"Вставьте предлог:\n\n<b>{чистая}</b>\n<i>({значение})</i>",
        "правильный": предлог,
        "варианты": варианты_предлогов(предлог)
    }


def вопрос_фраза(фраза, значение, все):
    return {
        "текст": f"Переведите устойчивую фразу:\n\n<b>{фраза}</b>",
        "правильный": очистить_текст(значение),
        "варианты": варианты_из_значений(значение, все)
    }


# ========== КЛАСС ТРЕНИРОВКИ ==========
class Тренировка:
    def __init__(self, uid, режим):
        self.uid = uid
        self.режим = режим
        self.текущий_вопрос = None

    def следующий_вопрос(self):
        д = ВСЕ_ДАННЫЕ
        реж = self.режим

        if реж == '1':
            сл = д['словарь']
            items = list(сл.items())
            random.shuffle(items)
            for слово, пер in items:
                хэш = f"v_{слово}"
                if not трекер.был_недавно_задан(self.uid, хэш):
                    трекер.отметить(self.uid, хэш)
                    self.текущий_вопрос = вопрос_словарь(слово, пер, сл)
                    return
            слово, пер = random.choice(items)
            self.текущий_вопрос = вопрос_словарь(слово, пер, сл)

        elif реж == '2':
            фр = д['фразовые']
            items = list(фр.items())
            random.shuffle(items)
            for гл, зн in items:
                хэш = f"ph_{гл}"
                if not трекер.был_недавно_задан(self.uid, хэш):
                    трекер.отметить(self.uid, хэш)
                    self.текущий_вопрос = вопрос_фразовый_перевод(гл, зн, фр)
                    return
            гл, зн = random.choice(items)
            self.текущий_вопрос = вопрос_фразовый_перевод(гл, зн, фр)

        elif реж == '3':
            ap = д['adj_prep']
            items = list(ap.items())
            random.shuffle(items)
            for фраза, зн in items:
                части = фраза.split()
                предлог = части[-1]
                хэш = f"ap_{фраза}"
                if not трекер.был_недавно_задан(self.uid, хэш):
                    трекер.отметить(self.uid, хэш)
                    self.текущий_вопрос = вопрос_предлог(фраза, предлог, зн)
                    return
            фраза, зн = random.choice(items)
            self.текущий_вопрос = вопрос_предлог(фраза, фраза.split()[-1], зн)

        elif реж == '4':
            vp = д['verb_prep']
            items = list(vp.items())
            random.shuffle(items)
            for фраза, зн in items:
                части = фраза.split()
                предлог = части[-1]
                хэш = f"vp_{фраза}"
                if not трекер.был_недавно_задан(self.uid, хэш):
                    трекер.отметить(self.uid, хэш)
                    self.текущий_вопрос = вопрос_предлог(фраза, предлог, зн)
                    return
            фраза, зн = random.choice(items)
            self.текущий_вопрос = вопрос_предлог(фраза, фраза.split()[-1], зн)

        elif реж == '5':
            фр = д['фразы']
            items = list(фр.items())
            random.shuffle(items)
            for фраза, зн in items:
                хэш = f"fr_{фраза}"
                if not трекер.был_недавно_задан(self.uid, хэш):
                    трекер.отметить(self.uid, хэш)
                    self.текущий_вопрос = вопрос_фраза(фраза, зн, фр)
                    return
            фраза, зн = random.choice(items)
            self.текущий_вопрос = вопрос_фраза(фраза, зн, фр)

    def проверить(self, ответ):
        if not self.текущий_вопрос:
            return False
        return ответ.strip().lower() == self.текущий_вопрос['правильный'].strip().lower()


# ========== СОСТОЯНИЯ ==========
активные_сессии = {}
состояния = {}

РЕЖИМЫ = {
    '1': 'Режим 1 — Словарный запас 📖',
    '2': 'Режим 2 — Фразовые глаголы 🔄',
    '3': 'Режим 3 — Прилагательные + предлоги 🔗',
    '4': 'Режим 4 — Глаголы + предлоги ✏️',
    '5': 'Режим 5 — Устойчивые фразы 💬',
}

КНОПКИ_РЕЖИМОВ = list(РЕЖИМЫ.values()) + ['🎲 Случайный режим']
КНОПКИ_ДА_НЕТ = ['✅ Да, начнём!', '❌ Нет, позже']


def клавиатура(кнопки, cols=1):
    markup = types.ReplyKeyboardMarkup(resize_keyboard=True, one_time_keyboard=False)
    for i in range(0, len(кнопки), cols):
        markup.row(*кнопки[i:i+cols])
    return markup


def клавиатура_ответов(варианты):
    markup = types.ReplyKeyboardMarkup(resize_keyboard=True, one_time_keyboard=True)
    for вариант in варианты:
        markup.row(вариант)
    markup.row('🔄 Сменить режим', '🏠 В меню')
    return markup


def убрать_клавиатуру():
    return types.ReplyKeyboardRemove()


def отправить_вопрос(uid):
    сессия = активные_сессии.get(uid)
    if not сессия or not сессия.текущий_вопрос:
        return
    в = сессия.текущий_вопрос
    текст = f"<b>Режим {сессия.режим}</b>\n\n{в['текст']}"
    bot.send_message(uid, текст, parse_mode='HTML', reply_markup=клавиатура_ответов(в['варианты']))


def показать_меню_режимов(uid):
    состояния[uid] = 'mode'
    текст = (
        "Выберите режим подготовки:\n\n"
        "📖 Режим 1 — Словарный запас\n"
        "🔄 Режим 2 — Фразовые глаголы\n"
        "🔗 Режим 3 — Прилагательные + предлоги\n"
        "✏️ Режим 4 — Глаголы + предлоги\n"
        "💬 Режим 5 — Устойчивые фразы"
    )
    bot.send_message(uid, текст, reply_markup=клавиатура(КНОПКИ_РЕЖИМОВ))


# ========== ОБРАБОТЧИКИ ==========
@bot.message_handler(commands=['start'])
def старт(message):
    uid = message.chat.id
    активные_сессии.pop(uid, None)
    состояния[uid] = 'start'
    bot.send_message(
        uid,
        "👋 Здравствуйте! Готовы начать подготовку к ЦЭ/ЦТ?",
        reply_markup=клавиатура(КНОПКИ_ДА_НЕТ, cols=2)
    )


@bot.message_handler(commands=['menu'])
def меню(message):
    показать_меню_режимов(message.chat.id)


@bot.message_handler(func=lambda m: True)
def обработать_сообщение(message):
    uid = message.chat.id
    текст = message.text.strip()
    состояние = состояния.get(uid, 'start')

    if текст == '✅ Да, начнём!':
        показать_меню_режимов(uid)
        return

    if текст == '❌ Нет, позже':
        состояния[uid] = 'start'
        bot.send_message(uid, "Хорошо! Пишите /start, когда будете готовы. 👍", reply_markup=убрать_клавиатуру())
        return

    if текст == '🎲 Случайный режим' or текст in КНОПКИ_РЕЖИМОВ:
        if текст == '🎲 Случайный режим':
            номер = str(random.randint(1, 5))
        else:
            номер = None
            for к, н in РЕЖИМЫ.items():
                if н == текст:
                    номер = к
                    break
        if номер:
            активные_сессии[uid] = Тренировка(uid, номер)
            состояния[uid] = 'session'
            активные_сессии[uid].следующий_вопрос()
            отправить_вопрос(uid)
        return

    if текст == '🔄 Сменить режим':
        активные_сессии.pop(uid, None)
        показать_меню_режимов(uid)
        return

    if текст == '🏠 В меню':
        активные_сессии.pop(uid, None)
        состояния[uid] = 'start'
        bot.send_message(uid, "👋 Готовы начать подготовку к ЦЭ/ЦТ?", reply_markup=клавиатура(КНОПКИ_ДА_НЕТ, cols=2))
        return

    if состояние == 'session' and uid in активные_сессии:
        сессия = активные_сессии[uid]
        правильно = сессия.проверить(текст)
        правильный_ответ = сессия.текущий_вопрос['правильный'] if сессия.текущий_вопрос else ''

        if правильно:
            bot.send_message(uid, "✅ Правильно!")
        else:
            bot.send_message(uid, f"❌ Неправильно!\nПравильный ответ: <b>{правильный_ответ}</b>", parse_mode='HTML')

        сессия.следующий_вопрос()
        if сессия.текущий_вопрос:
            отправить_вопрос(uid)
        else:
            bot.send_message(uid, "Все вопросы пройдены! Напишите /start для новой сессии.", reply_markup=убрать_клавиатуру())
        return

    if состояние != 'session':
        bot.send_message(uid, "Напишите /start чтобы начать. 👋")


# ========== ЗАПУСК ==========
print("Бот запущен и готов к работе!")
bot.infinity_polling()
