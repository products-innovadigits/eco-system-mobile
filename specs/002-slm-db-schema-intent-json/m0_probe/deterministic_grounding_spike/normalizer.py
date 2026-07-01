"""Question normalizer — dev-only spike component (T009d).

Pure functions only. No model calls, no I/O. Normalizes Arabic diacritics and
letter-shape variants, lowercases Latin text, and detects a coarse language tag
(ar / en / mixed) so downstream matching can work on a stable, comparable form
of the question.
"""

from __future__ import annotations

import re
import unicodedata

# Arabic combining diacritics (tashkeel) + tatweel, stripped entirely.
_TASHKEEL_RE = re.compile(
    "[ؐ-ًؚ-ٰٟۖ-ۜ۟-۪ۨ-ۭـ]"
)

# Letter-shape normalization map: alef/hamza/ya/ta-marbuta variants collapsed
# to one canonical form so lexicon/lookup matching is not defeated by
# orthographic variation in typed Arabic questions.
_LETTER_MAP = {
    "أ": "ا",  # أ -> ا
    "إ": "ا",  # إ -> ا
    "آ": "ا",  # آ -> ا
    "ٱ": "ا",  # ٱ -> ا
    "ى": "ي",  # ى -> ي
    "ة": "ه",  # ة -> ه (ta-marbuta -> ha)
}

_ARABIC_RE = re.compile(r"[؀-ۿ]")
_LATIN_RE = re.compile(r"[A-Za-z]")
_WHITESPACE_RE = re.compile(r"\s+")


def strip_tashkeel(text: str) -> str:
    return _TASHKEEL_RE.sub("", text)


def normalize_letters(text: str) -> str:
    return "".join(_LETTER_MAP.get(ch, ch) for ch in text)


def detect_language(text: str) -> str:
    has_ar = bool(_ARABIC_RE.search(text))
    has_en = bool(_LATIN_RE.search(text))
    if has_ar and has_en:
        return "mixed"
    if has_ar:
        return "ar"
    if has_en:
        return "en"
    return "unknown"


def normalize_question(raw: str) -> dict:
    """Normalize a raw question string.

    Returns a dict with the original text, the detected language (computed on
    the *original* text, before case folding), and the normalized text used
    for all downstream matching.
    """
    original = raw
    language = detect_language(original)

    text = unicodedata.normalize("NFKC", raw)
    text = strip_tashkeel(text)
    text = normalize_letters(text)
    text = text.lower()  # no-op on Arabic, folds Latin
    text = _WHITESPACE_RE.sub(" ", text).strip()

    return {
        "original": original,
        "language": language,
        "normalized": text,
    }
