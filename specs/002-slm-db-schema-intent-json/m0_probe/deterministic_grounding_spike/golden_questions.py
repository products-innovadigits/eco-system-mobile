"""Golden-question loader — dev-only spike component (T009d).

Parses the markdown table in `m0_probe/m0_golden_questions.md` (G01-G50) into
structured items so the spike runner can iterate them without hand-copying
questions. Read-only text parsing; no model, no DB.
"""

from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path

GOLDEN_QUESTIONS_PATH = Path(__file__).resolve().parents[1] / "m0_golden_questions.md"

_ROW_RE = re.compile(r"^\|\s*(G\d+)\s*\|")


@dataclass
class GoldenItem:
    id: str
    lang: str
    category: str
    question: str
    expected_intent: str
    expected_root: str
    expected_target_tables: str
    expected_filter: str
    expected_relationship: str
    expected_clarify: str
    notes: str


def _split_row(line: str) -> list[str]:
    line = line.strip()
    if line.startswith("|"):
        line = line[1:]
    if line.endswith("|"):
        line = line[:-1]
    return [cell.strip() for cell in line.split("|")]


def load_golden_questions(path: Path | str = GOLDEN_QUESTIONS_PATH) -> list[GoldenItem]:
    items: list[GoldenItem] = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            if not _ROW_RE.match(line):
                continue
            cells = _split_row(line)
            if len(cells) < 11:
                continue
            (
                qid, lang, category, question, intent, root, targets,
                filt, rel, clarify, notes,
            ) = cells[:11]
            items.append(
                GoldenItem(
                    id=qid,
                    lang=lang,
                    category=category,
                    question=question,
                    expected_intent=intent,
                    expected_root=root,
                    expected_target_tables=targets,
                    expected_filter=filt,
                    expected_relationship=rel,
                    expected_clarify=clarify,
                    notes=notes,
                )
            )
    return items
