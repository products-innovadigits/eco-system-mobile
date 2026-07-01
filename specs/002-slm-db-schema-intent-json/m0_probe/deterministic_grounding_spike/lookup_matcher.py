"""Lookup-value matcher — dev-only spike component (T009d).

Matches phrases in a normalized question to *enumerated* lookup values via
exact -> normalized -> fuzzy similarity, and always returns the verbatim
value from the schema's lookup list (or no match). This is the mechanism
that prevents the "الهامة" class of invented-value error: a candidate value
is only ever constructed from a recognized level word (عالية/متوسطة/منخفضة),
never from an arbitrary adjective, and the returned value is always copied
byte-for-byte from the allowed list.
"""

from __future__ import annotations

from difflib import SequenceMatcher

from lexicon import LEVEL_WORDS
from normalizer import normalize_letters, strip_tashkeel

DEFAULT_THRESHOLD = 0.72


def _norm(text: str) -> str:
    return normalize_letters(strip_tashkeel(text)).lower().strip()


def detect_level(normalized_question: str) -> str | None:
    """Return 'high' / 'medium' / 'low' if a recognized level word is present."""
    for level, words in LEVEL_WORDS.items():
        for w in words:
            if _norm(w) in normalized_question:
                return level
    return None


def best_lookup_match(
    candidate_phrase: str,
    allowed_values: list[str],
    threshold: float = DEFAULT_THRESHOLD,
) -> tuple[str | None, float]:
    """Return (verbatim allowed value, score) or (None, best_score_seen).

    Never returns a value that is not byte-for-byte present in
    `allowed_values` — this is the anti-hallucination guarantee.
    """
    if not candidate_phrase or not allowed_values:
        return None, 0.0

    cand_norm = _norm(candidate_phrase)
    best_value = None
    best_score = 0.0
    for value in allowed_values:
        value_norm = _norm(value)
        if cand_norm == value_norm:
            return value, 1.0
        score = SequenceMatcher(None, cand_norm, value_norm).ratio()
        if score > best_score:
            best_score = score
            best_value = value

    if best_score >= threshold:
        return best_value, best_score
    return None, best_score


def build_level_candidate(value_prefix: str, level: str) -> str:
    """Build the canonical '<prefix> <level>' phrase in the schema's own
    naming convention, e.g. ("مخاطر", "high") -> "مخاطر عالية"."""
    canonical_level_word = {
        "high": "عالية",
        "medium": "متوسطة",
        "low": "منخفضة",
    }[level]
    return f"{value_prefix} {canonical_level_word}"
